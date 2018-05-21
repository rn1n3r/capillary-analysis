%plotFOVfocus(fov, [targetID], plotCV, threshCV)
% fov is the cell containing the data for the field of view in question
% This version of the function does not deal with CV
%
% targetID is the list of capillary IDs to plot data for: all IDs will be
% plotted if this is empty
%

function plotFOVFocusNoCV(fov, varargin)

    % Get parameters
    % Target ID, if not supplied then set the value to all IDs in fov
    if nargin >= 2
        targetID = varargin{1};
        if isempty(targetID)
            targetID = [fov{:,1}];
        end
    else
        targetID = [fov{:,1}];
    end
    
    % Initialize variables for finding the axes
    minVal = 0;
    maxVal = 0;
    maxValCV = 0;
    maxMean = 0;

    % Get the min/max/maxCV for the axes
    for i = 1:length(targetID)

        values = nanmean(fov{i, 2}, 2);

        if (minVal == 0 || min(nanmean(values, 2)) < minVal)
            minVal = min(nanmean(values, 2));
        end
        if maxVal < max(nanmean(values, 2))
            maxVal = max(nanmean(values, 2));
        end
        
        if nanmean(values) > maxMean
            maxMean = nanmean(values);
        end

    end
    
    
    % Set variables for the subplot
    subPlotIndex = 1;
    subPlotWidth = ceil(length(targetID)/2);
    subPlotHeight = 2;


    % Loop to plot all specified capillary data
    for i = 1:length(targetID)
        % Find the index for the specified capillary
        capID = find([fov{:,1}] == targetID(i));

        % Calculate mean values
        values = nanmean(fov{capID, 2}, 2);

        subplot(subPlotHeight, subPlotWidth, subPlotIndex);

        fmean = values;
        if nargin >= 3 % normalize
            fmean = fmean./maxVal;
        end
    
        hold on
        plot(fmean);
        %scatter(1:520, fmean, [], 'b');
        %scatter(1:520, nanstd(fov{i ,2}, 0, 2), [], [0.5 0.5 0.5]);
        hold off
        
        if nargin >= 3 % normalize
            axis([1 520 0 1]);
        else
            axis([1 520 minVal maxVal]);
        end
        title(num2str(fov{capID, 1}));
        xlabel('Y-coordinate on path');
        ylabel('Average focus level');


        fprintf('%d\n', fov{capID, 1});
        fprintf('Average mean = %d\n', nanmean(values));
        fprintf('Average std = %d\n', nanmean(nanstd(fov{capID ,2}, 0, 2)));
        fprintf('Average CV = %d\n', nanmean(nanstd(fov{capID ,2}, 0, 2)./values));
        %percentage = sum(fmean >= maxMean) / sum(~isnan(values))

        subPlotIndex = subPlotIndex + 1;
    end

end


