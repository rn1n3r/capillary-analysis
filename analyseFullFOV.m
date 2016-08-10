% analyseFullFOV(fov, [targetID], nocv)


function analyseFullFOV(varargin)

% Initialize variables for finding the axes
minVal = 0;
maxVal = 0;
maxValCV = 0;
maxMean = 0;

% Get parameters
fov = varargin{1};

% Target ID, if not supplied then set the value to 0
if length(varargin) >= 2
    targetID = varargin{2};
    if isempty(targetID)
        targetID = 0;
    end
else
    targetID = 0;
end

% noCV, determines whether or not CV plots are plotted
noCV = false;
if length(varargin) == 3
    if strcmp(varargin{3}, 'nocv')
        noCV = true;
    end
end
 

% Get the min/max/maxCV for the axes
for i = 1:size(fov, 1)
    
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
    if nanmean(values) > maxMean
        maxMean = nanmean(values);
    end
end

% Set variables for the subplot
subPlotIndex = 1;
if targetID(1) == 0
    subPlotWidth = size(fov, 1);
else
    subPlotWidth = size(targetID, 2);
end


for i = 1:size(fov, 1)
    if any(targetID == fov{i, 1}) || targetID(1) == 0
        values = nanmean(fov{i, 2}, 2);
        
        subplot(2 - noCV, subPlotWidth, subPlotIndex);
        
        CV = nanstd(fov{i, 2}, 0, 2)./values;
        fmean = values;
        fmean(CV > 0.45) = NaN;
        
        underThresh = nanmean(values, 2);
        underThresh(CV <= 0.45) = NaN;
        
        hold on
        scatter(1:520, fmean, [], 'b');
        scatter(1:520, underThresh, [], [0.5 0.5 0.5]);
        scatter(1:520, nanstd(fov{i ,2}, 0, 2), [], 'r');
        hold off
        axis([1 520 minVal maxVal]);
        title(num2str(fov{i, 1}));
        xlabel('Y-coordinate on path');
        ylabel('Average focus level');
        
        if ~noCV
            subplot(2, size(fov, 1), i+size(fov, 1));
            scatter(1:520, nanstd(fov{i, 2}, 0, 2)./values);
            axis([1 520 0 maxValCV]);
            title([num2str(fov{i, 1}) ' CV']);
        end
        fprintf('%d\n', fov{i, 1});
        fprintf('Average mean = %d\n', nanmean(values));
        fprintf('Average std = %d\n', nanmean(nanstd(fov{i ,2}, 0, 2)));
        fprintf('Average CV = %d\n', nanmean(nanstd(fov{i ,2}, 0, 2)./values));
        %percentage = sum(fmean >= maxMean) / sum(~isnan(values))
        
        subPlotIndex = subPlotIndex + 1;
    end
    
end



end