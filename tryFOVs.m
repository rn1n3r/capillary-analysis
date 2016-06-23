% Clean and get variance data
clean;
load('varianceData.mat');


% FOV3
fnames = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV3-B/');
[areas3 idList3] = getCapillaries(var3);
total3 = analyseArea(areas3, idList3, fnames, 3);

clear fnames;

fnames = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV5-B/');
[areas5 idList5] = getCapillaries(var5);
total5 = analyseArea(areas5, idList5, fnames, 5);

clear fnames;

fnames = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV7-B/');
[areas7 idList7] = getCapillaries(var7);
total7 = analyseArea(areas7, idList7, fnames, 7);

clear fnames;

fnames = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV8-B/');
[areas8 idList8] = getCapillaries(var8);
total8 = analyseArea(areas8, idList8, fnames, 8);

clear fnames;

fnames = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOVp2-2-B/');
[areasp22 idListp22] = getCapillaries(varp22);
totalp22 = analyseArea(areasp22, idListp22, fnames, 22);

clear fnames;

fnames = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOVp2-4-P/');
[areasp24 idListp24] = getCapillaries(varp24);
totalp24 = analyseArea(areasp24, idListp24, fnames, 24);

total = [total3;total5;total7;total8;totalp22;totalp24;];