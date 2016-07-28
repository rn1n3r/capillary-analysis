function analyseFullFOV(fov, targetID)

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
    if fov{i, 1} == targetID || targetID == 0
        values = nanmean(fov{i, 2}, 2);
        figure;

        scatter(1:520, nanmean(values, 2));
        axis([1 520 minVal maxVal]);
        title(num2str(fov{i, 1}));
        xlabel('Y-coordinate on path');
        ylabel('Average focus level');
        figure;
        scatter(1:520, nanstd(fov{i ,2}, 0, 2)./values);
        %axis([1 520 minVal maxVal]);
        title([num2str(fov{i, 1}) ' CV']);
        fprintf('%d\n', fov{i, 1});
        fprintf('Average mean = %d\n', nanmean(values));
        fprintf('Average std = %d\n', nanmean(nanstd(fov{i ,2}, 0, 2)));
        fprintf('Average CV = %d\n', nanmean(nanstd(fov{i ,2}, 0, 2)./values));
    end
    
end



end