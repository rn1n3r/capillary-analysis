warning('off','all')
for i = 1:size(idList, 1)
    currentId = idList(i, 1);
    mask = firstFrame;
    mask(area ~= currentId) = NaN;
    glcm = graycomatrix(mask);
    fprintf('ID: %f \n', currentId);
    
    meanVal = mean2(firstFrame(area==currentId));
    
    stats = graycoprops(glcm);
    stats.Contrast = stats.Contrast / sum(sum(area == currentId)) / meanVal * 1e5;
    stats
    

end