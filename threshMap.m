function threshmap = threshMap(fov, meanValues, area, threshold, disp)

    for i = 1:length(fov)
        currentID = fov{i, 1};
        
        values = meanValues(:, i);
        
        [y, x] = ind2sub(size(area), find(area == currentID));
        
        for j = min(y):max(y)
            currentRow = find(area(j, :) == currentID);
            if values(j) > threshold
                area(j, currentRow) = 1;
            else
                area(j, currentRow) = 0;
            end
        end
    end
    
    threshmap = area;
   
    if disp
        imshow(area);
        
    end

end