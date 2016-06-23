function fm = analyseRBCFocus (listROI, I)

    fm = zeros(size(listROI, 1), 1);
    
    edgeI = edge(I, 'canny', 0.5);
    sum(sum(edgeI))
    imshow(edgeI);
    for i = 1:size(fm, 1)
        %fm(i) = fmeasure(I, 'GLLV', listROI(i, :));
        fm(i) = sum(sum(imcrop(edgeI, listROI(i, :))));
    end

end