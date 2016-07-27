function getFOVFocusData (processedPath, expNames, measure)

    tic
    clean

    % Start parallel processing pool
    matlabpool;

    % Set measure you want to test
    measure = 'BREN';

    processedPath = '/Volumes/DATA-2/Processed/20160722e/';
    capPath = strrep(processedPath, 'Processed', 'Captured');
    expNames = {'X20-14A', 'X20-14A-1', 'X20-14A-2', 'X20-14A-3'};

    fovData = cell(size(expNames, 2), 2);
    fovData(:, 1) = expNames';


    varFOV = imread([processedPath expNames{1} '/Functional-16bitImages/' expNames{1} '-16bit442Var.tif']);

    % 14A
    for i = 1:size(expNames, 2)
        I = imread([processedPath expNames{i} '/Functional-16bitImages/' expNames{i} '-16bit442Max.tif']);
        fname = getFnames([capPath '/442/' expNames{i} '/']);
        fovData{i, 2} = getFOVfmeasures(measure, varFOV, fname, I);   
        clear fnames;
    end



    % Close pool
    matlabpool close;
    toc
end