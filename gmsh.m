function gmsh (I)

    
    % Get the capillaries
    gray = rgb2gray(I);
    finalImage = zeros(size(gray));
    binaryImage = im2bw(gray);
    capillaries = ~binaryImage;
    
    s = regionprops(capillaries);
    
    for i = 1:numel(s)
        if s(i).Area > 20
            x = uint8(s(i).Centroid(2));
            y = uint8(s(i).Centroid(1));
            finalImage(x-1:x+1, y-1:y+1) = 1;
        end
            
            
    end
    
    % Attempt to get lines
    diffImg = imfilter(gray, fspecial('gaussian')) - gray;
    lines = edge(diffImg, 'canny', [0.2 0.3]);
    lines(~binaryImage) = 0;
    
    
    imshow(finalImage);
    figure;
    imshow(lines)
    


end