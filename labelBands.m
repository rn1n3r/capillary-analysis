% Edward Ho - May 4, 2016
% Takes the optical density ratio STI for a capillary, convert it to a
% binary iamge and then uses bwlabel (a "region growing algorithm??") to
% label the individual bands
function [labelledSTI, maxVal, OD_Ratio] = labelBands (OD_Ratio)
    
    % Change NaN to 0, non-zero values to 1
    OD_Ratio(isnan(OD_Ratio)) = 0 ;
    OD_Ratio(OD_Ratio > 0) = 1;
    OD_Ratio= logical(OD_Ratio);
    
    % Run bwlabel and get the maximum value (the number of bands
    % identified)
    labelledSTI = bwlabel(OD_Ratio,8);
    maxVal = max(labelledSTI(:));
    
    % Show the image with colours
    figure
    imshow(labelledSTI, [0 maxVal]);
    lines2 = lines;
    lines2(1,:) = 0;
    
    colormap(lines2);
    
    
    return

end

