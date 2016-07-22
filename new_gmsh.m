% CLEANS

J = I;
% Threshold green values to keep just enough to fill interstitial space
green = J(:,:,2);
green(green > 5) = 0;
J(:,:,2) = green;

J = rgb2gray(J);
imshow(im2bw(J, 0.02), []);