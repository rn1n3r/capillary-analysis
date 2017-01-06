
function fovData = getFOVFocusData (processedPath, fovList, measure)

    tic
    

    % Start parallel processing pool
    if matlabpool('size') == 0
        matlabpool;
    end

    fovListName = fovList;

    for i = 1:length(fovListName)
        fovListName{i} = strrep(fovList{i}, '-', '');
    end

    capPath = strrep(processedPath, 'Processed', 'Captured');

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