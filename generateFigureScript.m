clear
% Schematic to show getCapillaries function
varImg = imread('/Users/edward/Documents/capillary-data/Processed/X20-FOV3-B/Functional-16bitImages/X20-FOV3-B-16bit442Var.tif', 1);
fnames = getFnames('/Users/edward/Documents/capillary-data/Captured/442/X20-FOV3-B/');

testFrame = imread(fnames{2});

% hard-coded into getCapillaries
minCirc = 84;
cannyThresh = 0.2;



%% First figure: separated edges
edges = edge(varImg, 'canny', cannyThresh);
capillaries = bwlabel(edges);

dispCapillaries = capillaries;
dispCapillaries(dispCapillaries > 0) = 3;
dispCapillaries(dispCapillaries == 0) = 1;
dispCapillaries(dispCapillaries == 3) = 0;


imagesc(dispCapillaries);
imwrite(dispCapillaries, 'separated_edges.png');

%% Second - variance image

imwrite(varImg, 'variance.png');

%% Third figure
% Count the size of each edge
% One row for the ID and one for the actual size
%capillaries = dispCapillaries;
sizeOfEdges = zeros(max(capillaries(:)), 2);


for i = 1:max(capillaries(:))
   sizeOfEdges(i, 2) = sum(capillaries(:) == i);
   sizeOfEdges(i, 1) = i;
end

% Run markCapillaries, which uses findCapillaries to label all the
% capillaries
[capillaries, sizeOfEdges] = markCapillaries(capillaries, sizeOfEdges, size(sizeOfEdges, 1));

% Remove the small edges and set the size to 0 in sizeOfEdges
for i = 1:size(sizeOfEdges, 1)
   if sizeOfEdges(i, 2) < minCirc
       capillaries(capillaries == sizeOfEdges(i, 1)) = 0;
       sizeOfEdges (i,1:2) = 0;
   end    
end

% Remove edges with 0 length (marked in previous for loop)
sizeOfEdges = sizeOfEdges(any(sizeOfEdges,2),:);

% The mask is dilated twice... I don't know why but it works for now, not
% going to touch it
areaMask = imdilate(capillaries,strel('disk', 6));
areaMask = imdilate(areaMask, strel('disk', 3));

uniqueValues = unique(areaMask);
for i = 2:length(uniqueValues)
    areaMask(areaMask == uniqueValues(i)) = i - 1;
end

imagesc(areaMask)
cmap = autumn(length(uniqueValues));
cmap(1,:) = 1;
colormap(cmap)

imwrite(areaMask+1, cmap, 'labelled_capillaries.png');

%% Fourth figure: transparent areaMask over cells

overlay = testFrame;
%testFrame(areaMask ~= 4) = 0;

maxImg = imread('/Users/edward/Documents/capillary-data/Processed/X20-FOV3-B/Functional-16bitImages/X20-FOV3-B-16bit442Max.tif', 1);
a = drawRBCrect(testFrame, varImg, 3100, maxImg);

a(areaMask~=4) = 0;
cropped_region = double(a(100:300, 500:580));
cropped_region(cropped_region == 65535) = -8;
cropped_region(cropped_region == 0) = 65535;
cropped_region(cropped_region == -8) = 0;

% Convert bounding boxes to different colour

[y,x] = ind2sub(size(cropped_region), find(cropped_region == 0));

cropped_region = cat(3, cropped_region, cropped_region, cropped_region);
cropped_region = uint16(cropped_region);

for i = 1:length(y)
    cropped_region(y(i), x(i), :) = [65535 0 0];
end

imwrite(uint16(cropped_region), 'cropped_region.png')

%%
load('/Users/edward/Documents/capillary-data/data/TENV-all-02-13.mat');

focus = nanmean(fovData.('X20FOV3B'){6, 2}, 2);
scatter(focus./1E10, 1:520);
set(gca,'Ydir','reverse');
xlabel('Focus measure');
ylabel('Capillary y-coordinate');
set(gca,'FontSize', 30)
%%
function [capillaries, sizeOfEdges] = markCapillaries (capillaries, sizeOfEdges, numEdges)
% Goes through all the detected edges and mark them as individual
% capillaries by using findCorrespondingEdge 

% capillaries = image with labelled edges
% sizeOfEdge = matrix storing edge indices and length, will be used to
% store capillary info
% numCap = how many edges in the image

    % Base ID, also used to check if a capillary has been marked yet
    baseID = 600;
    id = baseID;
    capIndex = 1;
    
    % Sort the edges by length
    sizeOfEdges = flipud(sortrows(sizeOfEdges, 2));
    
    % Loop through the edges, and run findCorrespondingEdge to mark the
    % capillaries
    for i = 1:numEdges
        
        % Push the zeroed out values in the matrix to the end
        tempSizes = zeros(size(sizeOfEdges));
        idx = find(sizeOfEdges(:,1));
        tempSizes(1:length(idx), :) = sizeOfEdges(idx, :);
        sizeOfEdges = tempSizes;
        
        % Break out of the loop if the next edge is length 0 (all
        % capillaries should have been marked)
        if sizeOfEdges(capIndex,2) == 0
            break
        end
        
        % Skip over IDs that have already been marked
        while sizeOfEdges(capIndex,1) >= baseID
            capIndex = capIndex + 1;
        end
        % Mark current edge with the current working ID
        capillaries(capillaries == sizeOfEdges(capIndex,1)) = id;
        
        % Get the capillaries!
        % sameIdFound only looks at horizontal edges
        [capillaries, removedIds, numAdded, sameIdFound] = findCorrespondingEdge(capillaries, 20, id, baseID);       
        
        % Get rid of edges in the following cases:
        % 1. Pixels found in search were less than half the length, and it
        % did not find itself enough times (equal to its length)
        % 2. It did not find any unique IDs for removal, and it found
        % itself more than 3 times its length (indicates a horizontal edge)
        if (numAdded  <= sizeOfEdges(capIndex, 2)/2 && sameIdFound <= sizeOfEdges(capIndex, 2)) || (~sum(removedIds ~= id) && sameIdFound >= sizeOfEdges(capIndex,2) * 3)
            sizeOfEdges (capIndex,1:2) = 0;
            capIndex = capIndex - 1;
            capillaries(capillaries == id) = 0;
        else
            % Disregard own id
            removedIds = removedIds(removedIds ~= id); 
            
            
            if length(removedIds) == 2
                idxOne = sizeOfEdges(:, 1) == removedIds(1);
                idxTwo = sizeOfEdges(:, 1) == removedIds(2);
                
                if sizeOfEdges(idxOne, 2) > sizeOfEdges(idxTwo, 2)
                    toSearchAgain = removedIds(1);
                else
                    toSearchAgain = removedIds(2);
                end
                
                capillaries(capillaries == toSearchAgain) = 9999;
                capillaries = findCorrespondingEdge(capillaries, 20, 9999, baseID);
                capillaries(capillaries == 9999) = id;
            else
            
            % Remove ids from sizeOfEdge 
            for j = 1:length(removedIds)
                idx = find(sizeOfEdges(:,1) == removedIds(j));
                
                % Only delete if the edge is smaller than half of the
                % current edge (to prevent from accidentally wiping out
                % significant edges
                if sizeOfEdges(idx, 2) < sizeOfEdges(capIndex, 2) /2
                    %fprintf('ID: %d \n Size: %d\n\n', sizeOfEdges(idx, 1), sizeOfEdges(idx, 2)); 
                    capillaries(capillaries == removedIds(j)) = 0;
                    sizeOfEdges(idx, 1:2) = 0;
                end
            end
            end
            
            % Update sizeOfEdge
            sizeOfEdges(capIndex,1) = id;
            sizeOfEdges(capIndex,2) = sizeOfEdges(capIndex,2) + numAdded;
            
        end
        
        % Increments
        id = id + 500;
        capIndex = capIndex + 1;

    end
    
    % Get rid of zeros, sort
    sizeOfEdges = sizeOfEdges(any(sizeOfEdges,2),:);
    sizeOfEdges = flipud(sortrows(sizeOfEdges, 2));
    
end


function [capillaries, removedIds, numAdded, sameIdFound] = findCorrespondingEdge (capillaries, searchRadius, ID, baseID)
% Given an edge map (with approximation for capillary boundaries), a search
% radius and a capillary ID (to specify which edge to look at and what to
% mark the result with), find the corresponding edge of one edge of the
% capillary. The function goes along the path of the specified capillary
% and searches for a non-zero value within the search radius. These values
% are marked
% Also returns a list of IDs that were replaced during the edge search

% Get the path
[I, J] = ind2sub(size(capillaries), find(capillaries == ID));
path = [I, J];

% Removed ID stored here
removedIds = linspace(0,0,400);
idCounter = 1;
numAdded = 0;
sameIdFound = 0;
% Walk along the path, looking for non-zero values in radius
for i = 1:size(path,1)

    % Specify the current x-coordinate (searchOrigin) and the points in
    % the search radius (search).
    searchOriginY = path(i, 1);
    searchOriginX = path(i, 2);
    searchRangeY = searchOriginY - searchRadius * 0.75 : searchOriginY + searchRadius * 0.75;
    searchRangeX = searchOriginX - searchRadius : searchOriginX + searchRadius;
    
    % Mark if search range is bounded by the left border (needed for
    % finding the coordinates of these points)
    if sum(searchRangeX < 1)
        leftBound = true;
    else 
        leftBound = false;
    end
    
    if sum(searchRangeY < 1)
        topBound = true;
    else 
        topBound = false;
    end
    
    
    % Take only positive values that are within the frame
    searchRangeY = searchRangeY (searchRangeY >= 1 & searchRangeY <= size(capillaries, 1));
    searchRangeX = searchRangeX (searchRangeX >= 1 & searchRangeX <= size(capillaries, 2));
    
    % look for non-zero values, and set their value to the ID
    [y, ~] = find (capillaries(searchRangeY, path(i, 2)) ~= 0 & capillaries(searchRangeY, path(i, 2)) <= baseID | capillaries(searchRangeY, path(i, 2)) == ID);
    [~, x] = find (capillaries(path(i, 1), searchRangeX) ~= 0 & capillaries(path(i, 1), searchRangeX) <= baseID | capillaries(path(i,1), searchRangeX) == ID);
            
    % Results of the search
    % If the search range was bounded by the left border, the index is
    % simply the index within the search range (col)
    if leftBound
        resultIndexX = x;
    else
        resultIndexX = searchOriginX - (searchRadius + 1) + x;
    end
    
    if topBound
        resultIndexY = y;
    else
        resultIndexY = searchOriginY - (searchRadius*0.75 + 1) + y;
    end    
    
   
    % Store the IDs that are being replaced
    temp = [capillaries(path(i, 1), resultIndexX) capillaries(resultIndexY, path(i, 2))']; 
    temp = temp(~ismember(temp,removedIds)); % Only need new IDs
    
    removedIds (idCounter:idCounter+length(temp)-1) = temp;
   
    
    % Index for removedIds
    idCounter = idCounter + length(temp);
    
    % Sum of all the pixels added to this capillary section (don't include
    % current ID)
    numAdded = numAdded + sum(capillaries(resultIndexY, path(i, 2)) ~= ID)...
        + sum(capillaries(path(i, 1), resultIndexX) ~= ID);   

    % Count how many times it found itself (same ID)
    sameIdFound = sameIdFound + sum(capillaries(path(i, 1), resultIndexX) == ID); %...
        %sum(capillaries(resultIndexY, path(i, 2)) == ID);
   
    % Change the IDs
    capillaries(resultIndexY, path(i, 2)) = ID;
    capillaries(path(i, 1), resultIndexX) = ID;
    
    
end

% Remove the zeros in the array
removedIds = removedIds(removedIds~=0);


end