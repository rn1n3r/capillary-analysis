tic
% Clean and get variance data
clean;
load('data/varianceData.mat');

% Start parallel processing pool
matlabpool;

% FOV3
%fname = get_fnames('C:\Users\Edward\Documents\Files\DUROP\DATA-2\20150619/442/X20-FOV3-B/');
fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV3-B/');
[areas3, idList3] = getCapillaries(var3);
fov3 = cell(size(idList3, 1), 2);
fov3(:, 1) = num2cell(idList3(:, 1));
    
parfor i = 1:size(idList3, 1)
    temp = getFocusPath(fname, var3, idList3(i), 'CURV');
    fov3{i, 2} = temp;
end

clear fnames;

fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV5-B/');
[areas5 idList5] = getCapillaries(var5);
fov5 = cell(size(idList5, 1), 2);
fov5(:, 1) = num2cell(idList5(:, 1));

parfor i = 1:size(idList5, 1)
    temp = getFocusPath(fname, var5, idList5(i), 'CURV');
    fov5{i, 2} = temp;
end

clear fnames;

fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV7-B/');
[areas7 idList7] = getCapillaries(var7);
fov7 = cell(size(idList7, 1), 2);
fov7(:, 1) = num2cell(idList7(:, 1));

parfor i = 1:size(idList7, 1)
    temp = getFocusPath(fname, var7, idList7(i), 'CURV');
    fov7{i, 2} = temp;
end

clear fnames;

fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV8-B/');
[areas8 idList8] = getCapillaries(var8);
fov8 = cell(size(idList8, 1), 2);
fov8(:, 1) = num2cell(idList8(:, 1));

parfor i = 1:size(idList8, 1)
    temp = getFocusPath(fname, var8, idList8(i), 'CURV');
    fov8{i, 2} = temp;
end

clear fnames;

fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOVp2-2-B/');
[areasp22 idListp22] = getCapillaries(varp22);
fovp22 = cell(size(idListp22, 1), 2);
fovp22(:, 1) = num2cell(idListp22(:, 1));

parfor i = 1:size(idListp22, 1)
    temp = getFocusPath(fname, varp22, idListp22(i), 'CURV');
    fovp22{i, 2} = temp;
end

clear fnames;

fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOVp2-4-P/');
[areasp24 idListp24] = getCapillaries(varp24);
fovp24 = cell(size(idListp24, 1), 2);
fovp24(:, 1) = num2cell(idListp24(:, 1));

parfor i = 1:size(idListp24, 1)
    temp = getFocusPath(fname, varp24, idListp24(i), 'CURV');
    fovp24{i, 2} = temp;
end

% Close pool
matlabpool close;
toc
