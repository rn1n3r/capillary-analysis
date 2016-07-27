tic
% Clean and get variance data
clean;
load('data/varianceData.mat');

% Start parallel processing pool
matlabpool;

% Set measure you want to test
measure = 'BREN';

% FOV3
fname = getFnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV3-B/');
fov3 = getFOVfmeasures(measure, var3, fname);   

clear fnames;

% FOV5
fname = getFnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV5-B/');
fov5 = getFOVfmeasures(measure, var5, fname);   


clear fnames;

% FOV7
fname = getFnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV7-B/');
fov7 = getFOVfmeasures(measure, var7, fname);   

clear fnames;

% FOV8
fname = getFnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV8-B/');
fov8 = getFOVfmeasures(measure, var8, fname);   

clear fnames;

% FOVp22
fname = getFnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOVp2-2-B/');
fovp22 = getFOVfmeasures(measure, varp22, fname);   

clear fnames;

% FOVp24
fname = getFnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOVp2-4-P/');
fovp24 = getFOVfmeasures(measure, varp24, fname);   

clear fnames;

% Close pool
matlabpool close;
toc
