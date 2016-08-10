tic
% Clean and get variance data
clean;
load('/Users/edwardho/data/varianceData.mat');

% Start parallel processing pool
matlabpool;

% Set measure you want to test
measure = 'BREN';

% FOV3
fname = getFnames('/Volumes/DATA-2/Captured/20150619/454/X20-FOV3-B/');
maxImg = imread('/Volumes/DATA-2/Processed/20150619/X20-FOV3-B/Functional-16bitImages/X20-FOV3-B-16bit454Max.tif');
fov3 = getFOVfmeasures(measure, var3, fname, maxImg);   

clear fnames;

% FOV5
fname = getFnames('/Volumes/DATA-2/Captured/20150619/454/X20-FOV5-B/');
maxImg = imread('/Volumes/DATA-2/Processed/20150619/X20-FOV5-B/Functional-16bitImages/X20-FOV5-B-16bit454Max.tif');
fov5 = getFOVfmeasures(measure, var5, fname, maxImg);  


clear fnames;

% FOV7
fname = getFnames('/Volumes/DATA-2/Captured/20150619/454/X20-FOV7-B/');
maxImg = imread('/Volumes/DATA-2/Processed/20150619/X20-FOV7-B/Functional-16bitImages/X20-FOV7-B-16bit454Max.tif');
fov7 = getFOVfmeasures(measure, var7, fname, maxImg);   

clear fnames;

% FOV8
fname = getFnames('/Volumes/DATA-2/Captured/20150619/454/X20-FOV8-B/');
maxImg = imread('/Volumes/DATA-2/Processed/20150619/X20-FOV8-B/Functional-16bitImages/X20-FOV8-B-16bit454Max.tif');
fov8 = getFOVfmeasures(measure, var8, fname, maxImg);   

clear fnames;

% FOVp22
fname = getFnames('/Volumes/DATA-2/Captured/20150619/454/X20-FOVp2-2-B/');
maxImg = imread('/Volumes/DATA-2/Processed/20150619/X20-FOVp2-2-B/Functional-16bitImages/X20-FOVp2-2-B-16bit454Max.tif');
fovp22 = getFOVfmeasures(measure, varp22, fname, maxImg);  

clear fnames;

% FOVp24
fname = getFnames('/Volumes/DATA-2/Captured/20150619/454/X20-FOVp2-4-P/');
maxImg = imread('/Volumes/DATA-2/Processed/20150619/X20-FOVp2-4-P/Functional-16bitImages/X20-FOVp2-4-P-16bit454Max.tif');
fovp24 = getFOVfmeasures(measure, varp24, fname, maxImg);   

clear fnames;

% Close pool
matlabpool close;
toc
