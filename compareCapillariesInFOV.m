% analyseFullFOV(fov, [targetID], nocv)


function compareCapillariesInFOV (varargin)

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
    if any(targetID == fov{i, 1}) || targetID(1) == 0
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
end

for i = 1:size(fov, 1)
    if any(targetID == fov{i, 1}) || targetID(1) == 0
        values = nanmean(fov{i, 2}, 2);
        
        CV = nanstd(fov{i, 2}, 0, 2)./values;
        count = sum(~isnan(fov{i, 2}), 2);
      
        fmean = values;
        %fmean(CV > 0.45) = NaN;
        
        underThresh = nanmean(values, 2);
        underThresh(CV <= 0.45) = NaN;
        
        hold on
        scatter(1:520, fmean, [], 'DisplayName', num2str(fov{i, 1}));
        %scatter(1:520, underThresh, [], 'r');
        %scatter(1:520, nanstd(fov{i ,2}, 0, 2), [], [0.5 0.5 0.5]);
        %hold off
        axis([1 520 minVal 15]);
        title(num2str(fov{i, 1}));
        xlabel('Y-coordinate on path');
        ylabel('Average focus level');
        
%         if ~noCV
%             subplot(2, subPlotWidth, i+subPlotWidth);
%             scatter(1:520, nanstd(fov{i, 2}, 0, 2)./values);
%             axis([1 520 0 maxValCV]);
%             title([num2str(fov{i, 1}) ' CV']);
%         end

        if ~noCV
            scatter(1:520, count);
            axis([1 520 0 200]);
            title([num2str(fov{i, 1}) ' CV']);
        end
        fprintf('%d\n', fov{i, 1});
        fprintf('Average mean = %d\n', nanmean(values));
        fprintf('Average std = %d\n', nanmean(nanstd(fov{i ,2}, 0, 2)));
        fprintf('Average CV = %d\n', nanmean(nanstd(fov{i ,2}, 0, 2)./values));
        %percentage = sum(fmean >= maxMean) / sum(~isnan(values))

    end
    
end
legend('show')


end