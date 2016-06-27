% Clean and get variance data
clean;
load('data/varianceData.mat');


% FOV3
fname = get_fnames('C:\Users\Edward\Documents\Files\DUROP\DATA-2\20150619/442/X20-FOV3-B/');
%fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV3-B/');
[areas3, idList3] = getCapillaries(var3);
fov3 = cell(numel(idList3));
for i = 1:numel(idList3)
    temp = getFocusPath(fname, var3, idList3(i));
    fov3{i, 1} = idList3(i);
    fov3{i, 2} = temp;
end

clear fnames;

fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV5-B/');
[areas5 idList5] = getCapillaries(var5);
total5 = analyseArea(areas5, idList5, fname, 5);

clear fnames;

fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV7-B/');
[areas7 idList7] = getCapillaries(var7);
total7 = analyseArea(areas7, idList7, fname, 7);

clear fnames;

fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV8-B/');
[areas8 idList8] = getCapillaries(var8);
total8 = analyseArea(areas8, idList8, fname, 8);

clear fnames;

fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOVp2-2-B/');
[areasp22 idListp22] = getCapillaries(varp22);
totalp22 = analyseArea(areasp22, idListp22, fname, 22);

clear fnames;

fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOVp2-4-P/');
[areasp24 idListp24] = getCapillaries(varp24);
totalp24 = analyseArea(areasp24, idListp24, fname, 24);

% total = [total3;total5;total7;total8;totalp22;totalp24;];