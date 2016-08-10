% Try and find the subregion in a capillary path that is in-focus
% Returns the max/min/avg value of the focus measure found in the RBC at each
% location along the path of the capillary
%
% The range is 1 - 520, so if there is no capillary then the value is NaN
%
% This function only does one capillary to make parallel processing easier
% in getFOVfmeasures.m

function listFM = getPathFmeasures (fname, var, id, fmStr, maxImg)

    area = getCapillaries(var);
    
    % Store the max/min/avg fm, last column used to store number of RBCs
    % detected at that y-coordinate
        
    listFM = zeros(520, 1260);
    listFM(:, 2) = 1e7;
    
    for i = 1:numel(fname)
        frame = imread(fname{i});
        
        %frame = log10(double(maxImg)./double(frame));
        
        [listROI, circ] = findRBC(frame, area, id);
        fm = zeros(size(listROI, 1), 1);
    
        for j = 1:size(fm, 1)        
%             fm(i) = sum(sum(imcrop(edgeI, listROI(i, :))));
% 
%             glcm = graycomatrix(imcrop(I, listROI(i, :)));
%             gprops = graycoprops(glcm);
%             fm(i) = gprops.Correlation;

            fm(j) = fmeasure(frame, fmStr, listROI(j, :));
            fm(j) = fm(j)/mean2(imcrop(maxImg, listROI(j, :)));

        end

        % Normalize by RBC circumference
        fm = fm./circ;
        
        
        
        
        % In the case that there are NO RBCs found in the path
        if ~isempty(fm)
            for j = 1:numel(fm)
%                 % Max
%                 if listFM(listROI(j, 2), 1) < fm(j)
%                     listFM(listROI(j, 2), 1) = fm(j);
%                 end
%                 % Min
%                 if listFM(listROI(j, 2), 2) > fm(j) && ~isnan(fm(j))
%                     listFM(listROI(j, 2), 2) = fm(j);
%                 end
%                 % Sum
%                 listFM(listROI(j, 2), 3) = listFM(listROI(j, 2), 3) + fm(j);
%                 listFM(listROI(j, 2), 4) = listFM(listROI(j, 2), 4) + 1; % RBC count
                listFM(uint16(listROI(j, 2)+listROI(j,4)/2), i) = fm(j);
            end
        end
    end
    %listFM(:, 3) = listFM(:,3)./listFM(:, 4); % To finish average calculation 
    listFM(listFM == 0) = NaN;
    listFM(listFM == 1e7) = NaN;

end