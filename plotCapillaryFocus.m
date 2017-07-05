function plotCapillaryFocus(fov, targetID)

    % Initialize variables for finding the axes
    minVal = 0;
    maxVal = 0;
    index = 0;
    
    % Get the min/max/maxCV for the axes
    for i = 1:size(fov, 1)
        if targetID == fov{i, 1}
            % Set values to the mean across time
            values = nanmean(fov{i, 2}, 2);
            index = i;
            if (minVal == 0 || min(nanmean(values, 2)) < minVal)
                minVal = min(nanmean(values, 2));
            end
            if maxVal < max(nanmean(values, 2))
                maxVal = max(nanmean(values, 2));
            end
            break;
        end
    end



    fmean = values;

    hold on
    scatter(1:520, fmean, [], 'b');

    hold off
    axis([1 520 minVal maxVal]);
    title(num2str(fov{index, 1}));
    xlabel('Y-coordinate on path');
    ylabel('Average focus level');

    fprintf('%d\n', fov{i, 1});
    fprintf('Average mean = %d\n', nanmean(values));
    fprintf('Average std = %d\n', nanmean(nanstd(fov{i ,2}, 0, 2)));
    fprintf('Average CV = %d\n', nanmean(nanstd(fov{i ,2}, 0, 2)./values));

end

