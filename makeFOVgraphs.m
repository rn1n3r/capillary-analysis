function makeFOVgraphs(fov)

minVal = 0;
maxVal = 0;
for i = 1:size(fov, 1)
    values = fov{i, 2}(:, 3);
    
    if (minVal == 0 || min(values) < minVal)
        minVal = min(values);
    end
    if (maxVal < max(values))
        maxVal = max(values);
    end
    
end

medianVal = mean([maxVal minVal]);

for i = 1:size(fov, 1)
    values = fov{i,2}(:, 3);
    figure;
    scatter(1:520, values);
    title(num2str(fov{i, 1}));
    xlabel('Y-coordinate on path');
    ylabel('Average focus level');
    axis([1 520 minVal maxVal])
    percentage = sum(values >= medianVal) / sum(~isnan(values));
    fprintf('%d has %.3f of values equal to or above mean\n', fov{i, 1}, percentage)
end



end