% Wrapper function for getFOVfmeasures
% Initializes the max/varImg, and iterate through each fov specified
function fovData = analyseFOVFocus (processedPath, fovList, measure)

    tic
    
    % Start parallel processing pool
    if ispc
        p = gcp('nocreate');
    
    else
        if matlabpool('size') == 0
            matlabpool;
        end
    end
    fovListName = fovList;
    
    % Change the names for the FOVs to remove hyphens
    for i = 1:length(fovListName)
        fovListName{i} = strrep(fovList{i}, '-', '');
    end

    capPath = strrep(processedPath, 'Processed', 'Captured');
    
    % Create structure to store all the FOV data
    fovData = cell2struct(cell(size(fovListName)), fovListName, 2);

    for i = 1:length(fovList)
        fname = getFnames([capPath '/442/' fovList{i} '/']);
        maxImg = imread([processedPath fovList{i} '/Functional-16bitImages/' fovList{i} '-16bit442Max.tif']);
        varImg = imread([processedPath fovList{i} '/Functional-16bitImages/' fovList{i} '-16bit442Var.tif']);
        fovData.(fovListName{i}) = getFOVfmeasures(measure, varImg, fname, maxImg);

        fprintf('%s-%s...done!\n', measure, fovList{i})
    end

  
    toc
end