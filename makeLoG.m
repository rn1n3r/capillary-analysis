function img_blob = makeLoG(handles, img_tmp)


% apply the LoG filter
% img_blob = conv2(img_tmp, handles.logfilter, 'same');

% BOUNDARY OPTIONS FOR IMFILTER
% X
% Input array values outside the bounds of the array are implicitly assumed to have the value X. When no boundary option is specified, the default is 0.
% 'symmetric'
% Input array values outside the bounds of the array are computed by mirror-reflecting the array across the array border.
% 'replicate'
% Input array values outside the bounds of the array are assumed to equal the nearest array border value.
% 'circular'
% Input array values outside the bounds of the array are computed by implicitly assuming the input array is periodic.
% Output Size
% 'same'
% The output array is the same size as the input array. This is the default behavior when no output size options are specified.
% 'full'
% The output array is the full filtered result, and so is larger than the input array.
% Correlation and Convolution Options
% 'corr'
% imfilter performs multidimensional filtering using correlation, which is the same way that filter2 performs filtering. When no correlation or convolution option is specified, imfilter uses correlation.
% 'conv'
% imfilter performs multidimensional filtering using convolution.

img_blob = imfilter(img_tmp, handles.logfilter, 'replicate');


% assignin('base', 'img_blobfilter', img_blob);

% threshold it with the user input param
img_blob(img_blob < handles.threshold) = 0 ;
% assignin('base', 'img_blobthresh', img_blob);

return