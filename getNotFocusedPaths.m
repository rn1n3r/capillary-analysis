% Returns the ID of paths in the given FOV cell variable
% that are deemed "not in focus"
function getNotFocusedPaths(fov)
    
    minVal = 0;
    maxVal = 0;
    
    % First loop to find the max and min values
    for i = 1:size(fov, 1)
        
        % Get the average path fmeasure values
        values = fov{i,2}(:, 3);
        
        if (minVal == 0 || min(values) < minVal)
            minVal = min(values);
        end
        if (maxVal < max(values))
            maxVal = max(values);
        end
    end
    
    % Calculate the median as 
    medianVal = mean([minVal maxVal]);
    
    % Second loop, calculate the percentage that is above the median
    for i = 1:size(fov, 1)
        values = fov{i,2}(:, 3);
        percentage = sum(values >= medianVal) / sum(~isnan(values));
        fprintf('%d has %.3f of values equal to or above mean\n', fov{i, 1}, percentage);
    end


end