% analyseFullFOV(fov)


function generateHistogram (fov)

values= [];

for i = 1:size(fov, 1)
    
    values = [values; nanmean(fov{i, 2}, 2)];

    

    
end

hist(values, 100);
fprintf('Median is: %f\n', nanmedian(values));


end