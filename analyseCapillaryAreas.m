function data = analyseCapillaryAreas(area, idList, fnames)
    
    data = zeros(size(idList));
    data(:, 1) = idList(:, 1);
    
    
    [~, meanImg] = getVarianceImage(fnames);
    
    for i = 1:size(idList, 1)
        data(i, 2) = mean2(meanImg(area == idList(i)));
    end
   

end