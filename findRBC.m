% Takes a frame from a FOV and analyses the RBCs in a specified capillary
% Finds a rectangular region around each RBC so that focus measures can be
% applied to compare each cell

% frame = frame of FOV. If isEdge == 'edge', then this image is assumed to
% be background removed, and the edges detected using canny
% area = capillary map from getCapillaries()
% id = id of capillary of interest

function [listROI, circ] = findRBC (frame, area, id, maxImg, isEdge)
    
    if nargin < 4
        isEdge = true;
    end

    % If the isEdge parameter is not given, apply edge detection
    % Set all pixels that are not in the capillary of interest to zero
    
    if ~isEdge
        % FIRST, REMOVE THE BACKGROUND USING THE MAX IMAGE FROM THE ENTIRE
        % VIDEO
        % Yeah, I know it's not actually removing it since this "background"
        % fluctuates but it's a lot better than nothing
        frame = maxImg - frame;

        % Canny edge detection to find the borders of the  RBCs
        % Use canny on the WHOLE FRAME first to avoid weird results, but please
        % look into why
        frame = edge(frame, 'canny', 0.26);

    end
    % Find the indices of the edges in the path
    indices = find(area == id);
    
    % Crop the FOV to just have the relevant pixels
    rectCoords = autoGetRect(size(frame), [], [], indices, 0);
    rect = imcrop(frame, rectCoords);
    area = imcrop(area, rectCoords);
    
    rect(area ~= id) = 0;
    
    % Label all continuous regions
    rect = bwlabel(rect);
   
    % Processing
    minArea = 10;
    maxXSTD = 2;
    for i = 1:max(rect(:))
        % Delete regions that are very small (arbitrarily set by minArea)
        if sum(sum(rect == i)) < minArea
            rect(rect == i) = 0;
        end
        
        % Find the x values of each region
        cellIndices = find(rect == i);
        [~, cellSubs] = ind2sub(size(rect), cellIndices);        
        
        %If the standard deviation of the x-values is < 2 (again,
        %arbitrarily defined), then treat delete it (to get rid of lines,
        % etc)
        if std(cellSubs) < maxXSTD
            rect(rect == i) = 0;
        end
    end
    
    % Relabel
    rect = bwlabel(rect);
    
    
    % Initialize our data structure to store the rect info of each RBC
    % Also store the circumference
    listROI = zeros(max(rect(:)), 4);
    circ = zeros(max(rect(:)), 1);
    
    pixelPadding = 4;
    % For each region, call autoGetRect and store the info
    for i = 1:max(rect(:))
        indices = find(rect == i);
        circ(i) = sum(sum(rect == i));
        
        % 4 pixel padding seems to work...
        listROI(i, :) = autoGetRect(size(rect), size(frame), rectCoords, indices, pixelPadding);
%         newRect = imcrop(originalRect, listROI(i, :));
%         figure;
%         imshow(newRect, []); 
    end
    
    % Fix coordinates to be relative to entire FOV
    listROI = listROI + repmat ([rectCoords(1, 1:2) 0 0], size(listROI, 1), 1);
    
    
    % Attempt to fix the problem of boxes being too big by splitting them
    % up: loop through listROI to find large boxes (greater than 72 px
    % (arb)) and divide them by 36 (arb)
    temp = zeros(size(listROI,1)*3, 4); % Temporary matrix to store growing listROI
    tempCirc = zeros(size(circ,1)*3, 1);
    counter = 1;
    
    magicLength = 36;
    
    for i = 1:size(listROI, 1)
        temp(counter, 1:3) = listROI(i, 1:3);
        if listROI(i, 4) >= 72
            numOfDiv = floor(listROI(i, 4) / magicLength); % how many times 36 divides evenly
            hLast = listROI(i, 4) - magicLength*numOfDiv;
            
            % Increment x0 y0 for each box and set y_distances
            temp(counter:counter+numOfDiv-1, 4) = magicLength;
            temp(counter:counter+numOfDiv-1, [1 3]) = listROI(i*ones(1,numOfDiv), [1 3]);
            addToY = 36*(0:numOfDiv-1)';
            temp(counter:counter+numOfDiv-1, 2) = listROI(i, 2) + addToY;
            
            tempCirc(counter:counter+numOfDiv-1) = circ(i)*magicLength/listROI(i,4);
            
            % Update counter assuming no leftover distancs
            counter = counter+numOfDiv;
            
            % If the box we're dividing is not divisible by 36 (it rarely
            % is), then this makes the box for the last y_distance
            % Temporary solution as this box could be very small
            if hLast ~= 0
                temp(counter+numOfDiv, 4) = hLast;
                temp(counter+numOfDiv, [1 3]) = listROI(i, [1 3]);
                temp(counter+numOfDiv, 2) = listROI(i, 2) + addToY(end) + 36;
                
                tempCirc(counter+numOfDiv) = circ(i)*hLast/listROI(i,4);
                counter = counter + 1;
                
            end
            
        else
            temp(counter, 4) = listROI(i, 4);
            tempCirc(counter) = circ(i);
            counter = counter + 1;
        end
        
    end
    temp(~any(temp, 2), :) = [];
    tempCirc(~any(tempCirc,2), :) = [];
    listROI = temp;
    circ = tempCirc;


end

% This function takes an image and a list of points (indices)
% This function returns a rectangle encapsulating these points
% [xo yo width height]
% sizeLimit is a [y x] limit (for if the rectangle is within a larger frame
% that you don't want to exceed
% rect is [x y] (could be from autoGetRect before) that tells you where the
% current rectangle is within the large frame in sizelimit
function rect = autoGetRect (size, sizeLimit, rect, indices, p)
    
    if isempty(sizeLimit)
        sizeLimit = size;
    end
    if isempty(rect)
        rect = [0 0];
    else
        rect = rect(:, 1:2);
    end
    [subs(:, 1), subs(:, 2)] = ind2sub(size, indices);
    xo = min(subs(:, 2)) - p;
    yo = min(subs(:, 1)) - p;
    xf = max(subs(:, 2)) + p;
    yf = max(subs(:, 1)) + p;
    
    % In case padding takes it out of the image
    if xo + rect(1) < 1
        xo = 1;
    end
    if yo + rect(2) < 1
        yo = 1;
    end
    if xf + rect(1) > sizeLimit(2)
        xf = sizeLimit(2) - rect(1);
    end
    if yf + rect(2) > sizeLimit(1)
        yf = sizeLimit(1) - rect(2);

    end
            
    
    rect = [xo yo (xf - xo) (yf - yo)];
    
end


