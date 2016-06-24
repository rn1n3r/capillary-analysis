% Try and find the subregion in a capillary path that is in-focus
function listOfMaxFM = getFocusPath (fname, var, id)
    tic
    area = getCapillaries(var);
    
    % Store min_y, max_y, fm
    listOfMaxFM = zeros(100, 3);
    count = 1;
    h = waitbar(0, 'Processing, please wait');
    for i = 1:numel(fname)
        frame = imread(fname{i});
        listROI = findRBC(frame, area, id);
        fm = analyseRBCFocus(listROI, frame);
        
        % In the case that there are NO RBCs found in the path
        if ~isempty(fm)
            [listOfMaxFM(count, 3), ind] = max(fm);

            listOfMaxFM(count, 1:2) = [listROI(ind, 2) (listROI(ind, 2) + listROI(ind, 4))];

            count = count + 1;
        end
        if ~mod(i - 1, 200)
            waitbar(i/numel(fname));
        end
    end
    
    toc
    close(h)
end