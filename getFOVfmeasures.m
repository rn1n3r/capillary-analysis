% Gets the fmeasures of all capillaries in the FOV (from fname)
% Make sure to start parallel processing pool!
function fov = getFOVfmeasures(measure, var, fname, I)
    
    % Get the capillary IDs in the FOV
    [~, idList] = getCapillaries(var);
    fov = cell(size(idList, 1), 2);
    fov(:, 1) = num2cell(idList(:, 1));
    
    %tic    
    parfor i = 1:size(idList, 1)
        temp = getPathFmeasures(fname, var, idList(i, 1), measure, I);
        fov{i, 2} = temp;
    end
    
    %toc


end
