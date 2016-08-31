tic
% Clean and get variance data
clean;

% Start parallel processing pool
if matlabpool('size') == 0
    matlabpool;
end
% Set measure you want to test
measure = {'CURV', 'GLLV'};

% Defaults
%mainPath = '/Volumes/DATA-2/Captured/20150619/';
%fovList = {'X20-FOV3-B', 'X20-FOV5-B', 'X20-FOV7-B', 'X20-FOV8-B', 'X20-FOVp2-2-B', 'X20-FOVp2-4-P'};

mainPath = '/Volumes/DATA-2/Captured/20160722e/';
fovList = {'X20-13A', 'X20-13A-1', 'X20-13A-2', 'X20-13A-3'};

fovListName = fovList;

for i = 1:length(fovListName)
    fovListName{i} = strrep(fovList{i}, '-', '');
end

for j = 1:length(measure)
    
    fovData = cell2struct(cell(size(fovListName)), fovListName, 2);


    for i = 1:length(fovList)
        fname = getFnames([mainPath '442/' fovList{i} '/']);
        maxImg = imread([strrep(mainPath, 'Captured', 'Processed') fovList{i} '/Functional-16bitImages/' fovList{i} '-16bit442Max.tif']);
        varImg = imread([strrep(mainPath, 'Captured', 'Processed')  fovList{i} '/Functional-16bitImages/' fovList{i} '-16bit442Var.tif']);
        fovData.(fovListName{i}) = getFOVfmeasures(measure{j}, varImg, fname, maxImg);
        fprintf('%s-%s...done!\n', measure{j}, fovList{i})
    end

    save(['../data/asher/' measure{j} '-data'], 'fovData');

end
% Close pool
matlabpool close;
toc
