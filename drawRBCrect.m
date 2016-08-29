

function I = drawRBCrect(I, varImg, idList)
    
    for i = 1:length(idList)
       
        listROI = findRBC(I, getCapillaries(varImg), idList(i));
        if ~isempty(listROI)
            for j = 1:length(listROI)
                I(listROI(j, 2):listROI(j,4)+listROI(j,2), listROI(j,1)) = 0;
                I(listROI(j, 2):listROI(j,4)+listROI(j,2), listROI(j,1)+listROI(j,3)) = 0;
                I(listROI(j, 2), listROI(j,1):listROI(j,1)+listROI(j,3)) = 0;
                I(listROI(j, 4)+listROI(j,2), listROI(j,1):listROI(j,1)+listROI(j,3)) = 0;
            end
        end
    end

end