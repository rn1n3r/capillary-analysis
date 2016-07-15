tic
% Clean and get variance data
clean;
load('data/varianceData.mat');

% Start parallel processing pool
matlabpool;

% Set measure you want to test
measure = 'HISR';

% FOV3
fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV3-B/');
fov3 = tryDifferentFM(measure, var3, fname);   

clear fnames;

% FOV5
fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV5-B/');
fov5 = tryDifferentFM(measure, var5, fname);   

clear fnames;

% FOV7
fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV7-B/');
fov7 = tryDifferentFM(measure, var7, fname);   

clear fnames;

% FOV8  
fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV8-B/');
fov8 = tryDifferentFM(measure, var8, fname);   

clear fnames;

% FOVp22
fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOVp2-2-B/');
fovp22 = tryDifferentFM(measure, varp22, fname);   

clear fnames;

% FOVp24
fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOVp2-4-P/');
fovp24 = tryDifferentFM(measure, varp24, fname);   

clear fnames;

% Close pool
matlabpool close;
toc
