function makeFOVgraphs(fov, targetID)

minVal = 0;
maxVal = 0;
maxMean = 0;
for i = 1:size(fov, 1)
    values = fov{i, 2}(:, 3);
    
    if (minVal == 0 || min(values) < minVal)
        minVal = min(values);
    end
    if (maxVal < max(values))
        maxVal = max(values);
    end
    if nanmean(values) > maxMean
        maxMean = nanmean(values);
    end
    
end

medianVal = mean([maxVal minVal]);
fprintf('Mean is: %d\n', maxMean);
for i = 1:size(fov, 1)
    if targetID == 0 || targetID == fov{i, 1}
    values = fov{i,2}(:, 3);
    subplot(2, size(fov,1)/2, i);
    scatter(1:520, values);
    title(num2str(fov{i, 1}));
    xlabel('Y-coordinate on path');
    ylabel('Average focus level');
    axis([1 520 minVal maxVal])
    percentage = sum(values >= maxMean) / sum(~isnan(values));
    fprintf('%d: %.3f >= mean, %d pts, std = %d\n', fov{i, 1}, percentage, sum(values >= maxMean), nanstd(values));
    end
end



end