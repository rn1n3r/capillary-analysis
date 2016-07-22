tic
% Clean and get variance data
clean;
load('data/varianceData.mat');

% Start parallel processing pool
matlabpool;

% Set measure you want to test
measure = 'LAPM';

% FOV3
I = imread('/Volumes/DATA-2/Processed/20150619/X20-FOV3-B/Functional-16bitImages/X20-FOV3-B-16bit442Max.tif');
fname = getFnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV3-B/');
fov3 = getFOVfmeasures(measure, var3, fname, I);   

clear fnames;

% FOV5

I = imread('/Volumes/DATA-2/Processed/20150619/X20-FOV5-B/Functional-16bitImages/X20-FOV5-B-16bit442Max.tif');
fname = getFnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV5-B/');
fov5 = getFOVfmeasures(measure, var5, fname, I);   


clear fnames;

% FOV7
I = imread('/Volumes/DATA-2/Processed/20150619/X20-FOV7-B/Functional-16bitImages/X20-FOV7-B-16bit442Max.tif');
fname = getFnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV7-B/');
fov7 = getFOVfmeasures(measure, var7, fname, I);   

clear fnames;

% FOV8
I = imread('/Volumes/DATA-2/Processed/20150619/X20-FOV8-B/Functional-16bitImages/X20-FOV8-B-16bit442Max.tif');
fname = getFnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV8-B/');
fov8 = getFOVfmeasures(measure, var8, fname, I);   

clear fnames;

% FOVp22
tic;
I = imread('/Volumes/DATA-2/Processed/20150619/X20-FOVp2-2-B/Functional-16bitImages/X20-FOVp2-2-B-16bit442Max.tif');
fname = getFnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOVp2-2-B/');
fovp22 = getFOVfmeasures(measure, varp22, fname, I);   
toc;

clear fnames;

% FOVp24
I = imread('/Volumes/DATA-2/Processed/20150619/X20-FOVp2-4-P/Functional-16bitImages/X20-FOVp2-4-P-16bit442Max.tif');
fname = getFnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOVp2-4-P/');
fovp24 = getFOVfmeasures(measure, varp24, fname, I);   

clear fnames;

% Close pool
matlabpool close;
toc
