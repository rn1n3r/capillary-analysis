function img_tmp = newODGen(handles, img_tmp)


% PSEDUO OD GEN
img_max = imread(fullfile(handles.processedDir, strcat(handles.expName, '-442Max.tif')));

load(fullfile(strrep(handles.croppedDir, 'cropped images', 'cropmtx.mat')));

img_max = im2double(imcrop(img_max, cropMatrix));
% assignin('base', 'img_max', img_max);

img_tmp = log10(img_max ./ img_tmp);
 
% img_tmp = imcomplement(uint16(img_tmp .* 65536));
img_tmp = 65536 - (img_tmp .* 65536);

assignin('base', 'img_od', uint16(img_tmp));


%%%%%




return