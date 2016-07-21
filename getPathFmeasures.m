% Try and find the subregion in a capillary path that is in-focus
% Returns the max/min/avg value of the focus measure found in the RBC at each
% location along the path of the capillary
%
% The range is 1 - 520, so if there is no capillary then the value is NaN
%
% This function only does one capillary to make parallel processing easier
% in getFOVfmeasures.m

function listFM = getPathFmeasures (fname, var, id, measureStr, maxImg)

    area = getCapillaries(var);
    
    % Store the max/min/avg fm, last column used to store number of RBCs
    % detected at that y-coordinate
        
    listFM = zeros(520, 4);
    listFM(:, 2) = 1e7;
    
    for i = 1:numel(fname)
        frame = imread(fname{i});
        frame = log10(double(maxImg)./double(frame));
        listROI = findRBC(frame, area, id);
        fm = analyseRBCFocus(listROI, frame, measureStr);
        
        boxAreas = zeros(size(listROI, 1), 1);
        for j = 1:size(listROI, 1)
            boxAreas(j) = listROI(j, 3) * listROI(j, 4);
        end
        
        fm = fm./boxAreas;
        
        
        % In the case that there are NO RBCs found in the path
        if ~isempty(fm)
            for j = 1:numel(fm)
                % Max
                if listFM(listROI(j, 2), 1) < fm(j)
                    listFM(listROI(j, 2), 1) = fm(j);
                end
                % Min
                if listFM(listROI(j, 2), 2) > fm(j) && ~isnan(fm(j))
                    listFM(listROI(j, 2), 2) = fm(j);
                end
                % Sum
                listFM(listROI(j, 2), 3) = listFM(listROI(j, 2), 3) + fm(j);
                listFM(listROI(j, 2), 4) = listFM(listROI(j, 2), 4) + 1; % RBC count
            end
        end
    end
    listFM(:, 3) = listFM(:,3)./listFM(:, 4); % To finish average calculation 
    listFM(listFM == 0) = NaN;
    listFM(listFM == 1e7) = NaN;

end