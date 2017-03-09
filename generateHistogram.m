% analyseFullFOV(fov)


function [hist, edges] = generateHistogram (fov, hide)
if nargin < 2
    hide = false;
end

values= [];

for i = 1:size(fov, 1)
    
    values = [values; nanmean(fov{i, 2}, 2)];

    
end
[hist, edges] = histcounts(values, 100);
if ~hide
    
    histogram(values, 100);
    
end
fprintf('Median is: %f\n', nanmedian(values));


end