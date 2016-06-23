% Returns the variance image of all the images given in fnames

function var_img = getVarianceImage (fnames)

tic
% Get the mean of each pixel
mean_img = double(imread(fnames{1}));


N = size(fnames, 1);
SS = zeros(size(mean_img));
h = waitbar(0, 'Generating variance image...');

for i = 1: size(fnames, 1)
    
    if i <= size(fnames, 1) - 1
        mean_img = mean_img + double(imread(fnames{i + 1}));
    end
    
    % Calculate
    SS = SS + double(imread(fnames{i})).^2; 
    
    if ~mod(i, 200)
        waitbar(i/size(fnames, 1));
    end
  
end

close(h);

mean_img = mean_img./size(fnames, 1);
var_img = (SS / N) - mean_img.^2;


toc

end