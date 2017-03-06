function threshmap = threshMap(fov, area, threshold, disp)

    for i = 1:length(fov)
        currentID = fov{i, 1};
        
        values = nanmean(fov{i, 2}, 2);
        %stdValues = nanstd(fov{i, 2}, 0, 2);
        %CV = nanstd(fov{i, 2}, 0, 2)./values;
        
        
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