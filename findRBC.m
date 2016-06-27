% Takes a frame from a FOV and analyses the RBCs in a specified capillary
% Finds a rectangular region around each RBC so that focus measures can be
% applied to compare each cell

% frame = frame of FOV
% area = capillary map from getCapillaries()
% id = id of capillary of interest

function listROI = findRBC (frame, area, id)
    
    
    
    % Apply edge detection and set all pixels that are not in the capillary
    % of interest to zero
    
    % Find the indices of the edges in the path
    indices = find(area == id);
    
    % Crop the FOV to just have the relevant pixels
    rectCoords = autoGetRect(size(frame), [], [], indices, 0);
    rect = imcrop(frame, rectCoords);
    area = imcrop(area, rectCoords);
    
    rect = edge(rect, 'canny', 0.26);
    rect(area ~= id) = 0;
    
    % Label all continuous regions
    rect = bwlabel(rect);
    
    % Processing
    for i = 1:max(rect(:))
        % Delete regions that are very small (arbitrarily set to 10 px)
        if sum(sum(rect == i)) < 10
            rect(rect == i) = 0;
        end
        
        % Find the x values of each region
        cellIndices = find(rect == i);
        [~, cellSubs] = ind2sub(size(rect), cellIndices);        
        
        % If the standard deviation of the x-values is < 2 (again,
        % arbitrarily defined), then treat delete it (to get rid of lines,
        % etc)
        if std(cellSubs) < 2
            rect(rect == i) = 0;
        end
    end
    
    % Relabel
    rect = bwlabel(rect);
    
    % Initialize our data structure to store the rect info of each RBC
    listROI = zeros(max(rect(:)), 4);
    
    % For each region, call autoGetRect and store the info
    for i = 1:max(rect(:))
        indices = find(rect == i);
        listROI(i, :) = autoGetRect(size(rect), size(frame), rectCoords, indices, 4);
%         newRect = imcrop(originalRect, listROI(i, :));
%         figure;
%         imshow(newRect, []);
    end
    
    % Fix coordinates to be relative to entire FOV
    listROI = listROI + repmat ([rectCoords(1, 1:2) 0 0], size(listROI, 1), 1);
    
    % Testing purposes, show the labelled RBC edges
%     newjet = jet;
%     newjet(1, :) = 0;
%     
%     imshow(rect, []);
%     colormap(newjet);


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
        xf = size(2);
    end
    if yf + rect(2) > sizeLimit(1)
        yf = size(1);
    end
        
    
    rect = [xo yo (xf - xo) (yf - yo)];
    
end


