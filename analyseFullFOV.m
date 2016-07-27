function analyseFullFOV(fov)

minVal = 0;
maxVal = 0;
maxMean = 0;
for i = 1:size(fov, 1)
    values = fov{i,2};
    values(values == 0) = NaN;
    values(values == 1e7) = NaN;
    fov{i, 2} = values;
    
    if (minVal == 0 || min(nanmean(values, 2)) < minVal)
        minVal = min(nanmean(values, 2));
    end
    if maxVal < max(nanmean(values, 2))
        maxVal = max(nanmean(values, 2));
    end
    
end


for i = 1:size(fov, 1)
    if fov{i, 1} == 600
        values = fov{i, 2};
        figure;

        scatter(1:520, nanmean(values, 2));
        axis([1 520 minVal maxVal]);
        title(num2str(fov{i, 1}));
        xlabel('Y-coordinate on path');
        ylabel('Average focus level');
        fprintf('%d: Average std = %f\n', fov{i, 1}, nanmean(nanstd(values,0,2))/1e5);
    end
    
end



end