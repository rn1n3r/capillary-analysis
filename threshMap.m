% Generate a mapping of true/false (focus/not focus) on the capillaries of
% an ids based on a given threshold value

% ids = cell with capillary ids as column 1 and
%                 focus data as column 2

% capMask is the capillary mask of the FOV (from getCapillaries)

% threshold is the thresold value

% disp is a boolean variable indicating whether the resulting threshold map
% should be displayed

% meanValues is an array with time-averaged focus data for each capillary
% on each row. If an empty array is passed, this is calculated in the
% function
function threshmap = threshMap(ids, capMask, threshold, disp, meanValues)

    for i = 1:length(ids)
        currentID = ids{i, 1};
        
        if isempty(meanValues)
            meanValues = zeros(520, length(ids));
            for j = 1:length(ids)
               meanValues(:, j) = nanmean(ids{j,2},2); 
            end
        end
        
        values = meanValues(:, i);
        
        [y, x] = ind2sub(size(capMask), find(capMask == currentID));
        
        for j = min(y):max(y)
            currentRow = find(capMask(j, :) == currentID);
            if values(j) > threshold
                capMask(j, currentRow) = 1;
            else
                capMask(j, currentRow) = 0;
            end
        end
    end
    
    threshmap = capMask;
   
    if disp
        imshow(capMask, []);
        
    end

end