close all;
[fnames, path] = get_fnames(path);
h = figure;
frame = imread(fnames{80});
imshow(frame, []);

a = 1;
while a ~= 0  
rect = getrect(h);
acmo = fmeasure(frame, 'WAVS', rect)
a = input('Type 0 to end ');


end