% Try and find the subregion in a capillary path that is in-focus
function listOfMaxFM = getFocusPath (fname, var, id)
    tic
    area = getCapillaries(var);
    
    % Store min_y, max_y, fm
    % listOfMaxFM = zeros(100, 3);
    
    % Store the focus measure and the length of the box at each
    % y-coordinate
    
    listOfMaxFM = zeros(520, 2);
    
    count = 1;
    h = waitbar(0, 'Processing, please wait');
    for i = 1:numel(fname)
        frame = imread(fname{i});
        listROI = findRBC(frame, area, id);
        fm = analyseRBCFocus(listROI, frame);
        
        % In the case that there are NO RBCs found in the path
        if ~isempty(fm)
%             [listOfMaxFM(count, 3), ind] = max(fm);
% 
%             listOfMaxFM(count, 1:2) = [listROI(ind, 2) (listROI(ind, 2) + listROI(ind, 4))];
            for j = 1:numel(fm)
                if listOfMaxFM(listROI(j, 2), 1) < fm(j)
                    listOfMaxFM(listROI(j, 2), 1) = fm(j);
                    listOfMaxFM(listROI(j, 2), 2) = listROI(j, 4);
                end
            end

            count = count + 1;
        end
        if ~mod(i - 1, 200)
            waitbar(i/numel(fname));
        end
    end
    listOfMaxFM(listOfMaxFM == 0) = NaN;
    toc
    close(h)
end