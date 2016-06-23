function fm = analyseRBCFocus (listROI, I)

    fm = zeros(size(listROI, 1), 1);
    
    for i = 1:size(fm, 1)
        fm(i) = fmeasure(I, 'CONT', listROI(i, :));
    end

end