

function boxI = drawRBCrect(I, varImg, idList, maxImg)
    area = getCapillaries(varImg);
    boxI = I;
    for i = 1:length(idList)
       
        listROI = findRBC(I, area, idList(i), maxImg);
        if ~isempty(listROI)
            for j = 1:size(listROI, 1)
                boxI(listROI(j, 2):listROI(j,4)+listROI(j,2), listROI(j,1)) = 2^16;
                boxI(listROI(j, 2):listROI(j,4)+listROI(j,2), listROI(j,1)+listROI(j,3)) = 2^16;
                boxI(listROI(j, 2), listROI(j,1):listROI(j,1)+listROI(j,3)) = 2^16;
                boxI(listROI(j, 2)+listROI(j,4), listROI(j,1):listROI(j,1)+listROI(j,3)) = 2^16;
            end
        end
    end

end