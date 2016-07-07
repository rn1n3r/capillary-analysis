% Clean and get variance data
clean;
load('data/varianceData.mat');

% Start parallel processing pool
matlabpool;

measures = {'CONT', 'CURV', 'DCTE', 'GDER', 'HELM', 'HISE'}; % 'SFRQ', 'TENG', 'TENV', 'VOLA', 'WAVV', 'WAVS'}

[areas5 idList5] = getCapillaries(var5);
fov5 = cell(size(idList5, 1), size(measures, 2) + 1);
fov5(:, 1) = num2cell(idList5(:, 1));
fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV5-B/');

for j = 1:size(measures, 2)
    tic    
    index = j + 1;
    currentMeasure = measures{j};
    parfor i = 1:size(idList5, 1)
        temp = getFocusPath(fname, var5, idList5(i), currentMeasure);
        fov5{i, index} = temp;
    end                                                                                                                                                                                                                                                                                                                                                                                                                           
    toc
end

% Close pool
matlabpool close;
