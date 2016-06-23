% Sliding window approach to find the area in a picture with the greatest
% adjusted variance (= var/mean)
function vars = varHist (I)

tic


% Window dimensions (M is height, N is width)
M = 130;
N = 116;

% Declare variables for the convolution used to calculate variance
n = numel(I);
s = conv2(I, ones(M, N), 'same');
q = I.^2;
q = conv2(q, ones(M, N), 'same');
mean = conv2(I, ones(M, N)/n, 'same');

% Calculation
vars = (q - s.^2./n)./(n-1);
vars = vars./mean;


% The values of vars represent the variances of the points in the window
% centered at the current point. Because of this, we can get rid of values
% that are close enough to the borders that they could not be variances of
% the full dimension of points in a window

% Get rid of these border points
% vars(1:M, :) = 0;
% vars(size(I, 1) - M :end, :) = 0;
% 
% vars(:, 1:N) = 0;
% vars(:, size(I, 2)-N:end) = 0;


% parfor i = 1:size(I,1) - M 
%     val = zeros(1, size(I,2) - N);
%     for j = 1:size(I,2) - N
%         currentImg = I(i:M + (i - 1), j:N + (j - 1));
%         val(j) = var(currentImg(:))/mean(currentImg(:));
%              
%     end
%     vars(i, :) = val;
% end


% Show the section with the highest variance
tempVars = vars;

[~, idx] = max(tempVars(:));
[i j] = ind2sub(size(tempVars), idx);

imshow(I(i:M + i, j:N + j), []);

figure
imshow(vars, [])

 


figure
hist(vars(:))
toc

end