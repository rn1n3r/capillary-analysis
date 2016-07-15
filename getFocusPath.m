% Try and find the subregion in a capillary path that is in-focus
function listFM = getFocusPath (fname, var, id, measureStr)
    tic
    area = getCapillaries(var);
    
    % Store min_y, max_y, fm
    % listOfMaxFM = zeros(100, 3);
    
    % Store the max/min/avg fm, last column used to store number of RBCs
    % with that y-coordinate
    % y-coordinate
    
    listFM = zeros(520, 4);
    listFM(:, 2) = 1e7;
    
    %h = waitbar(0, 'Processing, please wait');
    for i = 1:numel(fname)
        frame = imread(fname{i});
        listROI = findRBC(frame, area, id);
        fm = analyseRBCFocus(listROI, frame, measureStr);
        
        % In the case that there are NO RBCs found in the path
        if ~isempty(fm)
            for j = 1:numel(fm)
                if listFM(listROI(j, 2), 1) < fm(j)
                    listFM(listROI(j, 2), 1) = fm(j);
                end
                if listFM(listROI(j, 2), 2) > fm(j) && ~isnan(fm(j))
                    listFM(listROI(j, 2), 2) = fm(j);
                end
                listFM(listROI(j, 2), 3) = listFM(listROI(j, 2), 3) + fm(j);
                listFM(listROI(j, 2), 4) = listFM(listROI(j, 2), 4) + 1;
            end
        end
        if ~mod(i - 1, 200)
            %waitbar(i/numel(fname));
        end
    end
    listFM(listFM == 0) = NaN;
    listFM(listFM == 1e7) = NaN;
    
    toc
    %close(h)
end