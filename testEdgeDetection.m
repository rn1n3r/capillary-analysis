function testEdgeDetection (I)
close all;
figure
imshow(I, []);
title('Image');

% Sobel
figure;
[sobel, sobel_thresh] = edge(I, 'sobel', []);
imshow(sobel);
title('Sobel');
fprintf('Sobel threshold: %f\n', sobel_thresh);

% canny
figure;
[canny, canny_thresh] = edge(I, 'canny', 0.2);
imshow(canny);
title('Canny');
fprintf('Canny threshold: %f %f\n', canny_thresh(1), canny_thresh(2));





end