function analyseFullFOV(varargin)

fov = varargin{1};

if (length(varargin) >= 2)
    nameStr = varargin{2};
end

if (length(varargin) == 3)
    targetID = varargin{3};
else
    targetID = 0;
end
 
minVal = 0;
maxVal = 0;
maxValCV = 0;
maxMean = 0;
for i = 1:size(fov, 1)
    values = fov{i,2};
    values(values == 0) = NaN;
    values(values == 1e7) = NaN;
    fov{i, 2} = values;
    
    values = nanmean(fov{i, 2}, 2);
    
    if (minVal == 0 || min(nanmean(values, 2)) < minVal)
        minVal = min(nanmean(values, 2));
    end
    if maxVal < max(nanmean(values, 2))
        maxVal = max(nanmean(values, 2));
    end
    
    if maxValCV < max(nanstd(fov{i ,2}, 0, 2)./values);
        maxValCV = max(nanstd(fov{i ,2}, 0, 2)./values);
    end
    
end



for i = 1:size(fov, 1)
    if fov{i, 1} == targetID || targetID == 0
        values = nanmean(fov{i, 2}, 2);
        subplot(2, size(fov, 1), i);
        
        hold on
        scatter(1:520, nanmean(values, 2), [], 'b');
        scatter(1:520, nanstd(fov{i ,2}, 0, 2), [], 'r');
        hold off
        axis([1 520 minVal maxVal]);
        title(num2str(fov{i, 1}));
        xlabel('Y-coordinate on path');
        ylabel('Average focus level');
        
        subplot(2, size(fov, 1), i+size(fov, 1));
        scatter(1:520, nanstd(fov{i ,2}, 0, 2)./values);
        axis([1 520 0 maxValCV]);
        title([num2str(fov{i, 1}) ' CV']);
        fprintf('%d\n', fov{i, 1});
        fprintf('Average mean = %d\n', nanmean(values));
        fprintf('Average std = %d\n', nanmean(nanstd(fov{i ,2}, 0, 2)));
        fprintf('Average CV = %d\n', nanmean(nanstd(fov{i ,2}, 0, 2)./values));
    end
    
end



end