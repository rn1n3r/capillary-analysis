function heatmap = heatMap(fov, area, disp)

    for i = 1:length(fov)
        currentID = fov{i, 1};
        
        values = nanmean(fov{i, 2}, 2);
        stdValues = nanstd(fov{i, 2}, 0, 2);
        CV = nanstd(fov{i, 2}, 0, 2)./values;
        
        values(CV > 0.45) = 0.5;
        
        [y, x] = ind2sub(size(area), find(area == currentID));
        
        for j = min(y):max(y)
            currentRow = find(area(j, :) == currentID);
            area(j, currentRow) = values(j);
        end
    end
    
    heatmap = area;
    
    if disp
        imshow(area, []);
        colormap(jet);
    end

end