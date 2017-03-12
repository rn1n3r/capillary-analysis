% analyseFullFOV(fov)


function [histo, edges] = generateHistogram (fov, hide)
if nargin < 2
    hide = false;
end

values= [];

for i = 1:size(fov, 1)
    
    values = [values; nanmean(fov{i, 2}, 2)];

    
end

% Use the more updated histcounts function if on PC
if ispc
    [histo, edges] = histcounts(values, 100);
else
    [histo, centers] = hist(values, 100);
    d = diff(centers)/2;
    edges = [centers(1)-d(1), centers(1:end-1)+d, centers(end)+d(end)];
    
if ~hide
    
    histogram(values, 100);
    
end
fprintf('Median is: %f\n', nanmedian(values));


end