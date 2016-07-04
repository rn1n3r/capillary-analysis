 function fm = analyseRBCFocus (listROI, I)

    fm = zeros(size(listROI, 1), 1);
    
    for i = 1:size(fm, 1)
        %fm(i) = fmeasure(I, 'GLVN', listROI(i, :));
        %fm(i) = sum(sum(imcrop(edgeI, listROI(i, :))));
        
        % Graycoprops
%         glcm = graycomatrix(imcrop(I, listROI(i, :)));
%         gprops = graycoprops(glcm);
%         fm(i) = gprops.Correlation;

%         fm(i) = fmeasure(I, 'BREN', listROI(i, :));
          fm(i) = fmeasure(I, 'LAPV', listROI(i, :));
    end

end