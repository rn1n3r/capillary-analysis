function gmsh (I)

    
    % Get the capillaries
    g = rgb2gray(I);
    finalImage = zeros(size(g));
    binaryImage = im2bw(g);
    capillaries = ~binaryImage;
    
    s = regionprops(capillaries);
    
%     for i = 1:numel(s)
%         if s(i).Area > 20
%             x = uint16(s(i).Centroid(2));
%             y = uint16(s(i).Centroid(1));
%             finalImage(x-1:x+1, y-1:y+1) = 1;
%         end    
%     end
    
    % Attempt to get interstitial
    green = I(:, :, 2);
    
    % Binary threshold
    green(green < 153) = 0;
    
    % Convert to binary, use bwlabel
    green = im2bw(green);
    green = bwlabel(green);
    imshow(green);
    figure;
    % Get second longest label (first will be 0)
    uniqueLabel = unique(green)
    valueCount = histc(green(:), uniqueLabel)
    [~, idx] = max(valueCount)
    valueCount(idx) = 0;
    [~, idx] = max(valueCount)
    label = uniqueLabel(idx);
    
    % Show the labelled image
    imshow(green == label);
    
    
    
  


end