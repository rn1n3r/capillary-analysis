% Clean and get variance data
clean;
load('data/varianceData.mat');


% FOV3
%fname = get_fnames('C:\Users\Edward\Documents\Files\DUROP\DATA-2\20150619/442/X20-FOV3-B/');
fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV3-B/');
[areas3, idList3] = getCapillaries(var3);
fov3 = cell(size(idList3, 1), 2);
fov3(:, 1) = {idList3(:, 1)};
    
parfor i = 1:size(idList3, 1)
    temp = getFocusPath(fname, var3, idList3(i));
    fov3{i, 2} = {temp};
end

clear fnames;

% fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV5-B/');
% [areas5 idList5] = getCapillaries(var5);
% fov5 = cell(size(idList5, 1), 2);
% for i = 1:size(idList5, 1)
%     temp = getFocusPath(fname, var5, idList5(i));
%     fov5{i, 1} = idList5(i);
%     fov5{i, 2} = temp;
% end
% 
% clear fnames;
% 
% fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV7-B/');
% [areas7 idList7] = getCapillaries(var7);
% fov7 = cell(size(idList7, 1), 2);
% for i = 1:size(idList7, 1)
%     temp = getFocusPath(fname, var7, idList7(i));
%     fov7{i, 1} = idList7(i);
%     fov7{i, 2} = temp;
% end
% 
% clear fnames;
% 
% fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOV8-B/');
% [areas8 idList8] = getCapillaries(var8);
% fov8 = cell(size(idList8, 1), 2);
% for i = 1:size(idList8, 1)
%     temp = getFocusPath(fname, var8, idList8(i));
%     fov8{i, 1} = idList8(i);
%     fov8{i, 2} = temp;
% end
% 
% clear fnames;
% 
% fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOVp2-2-B/');
% [areasp22 idListp22] = getCapillaries(varp22);
% fovp22 = cell(size(idListp22, 1), 2);
% for i = 1:size(idListp22, 1)
%     temp = getFocusPath(fname, varp22, idListp22(i));
%     fovp22{i, 1} = idListp22(i);
%     fovp22{i, 2} = temp;
% end
% 
% clear fnames;
% 
% fname = get_fnames('/Volumes/DATA-2/Captured/20150619/442/X20-FOVp2-4-P/');
% [areasp24 idListp24] = getCapillaries(varp24);
% fovp24 = cell(size(idListp24, 1), 2);
% for i = 1:size(idListp24, 1)
%     temp = getFocusPath(fname, varp24, idListp24(i));
%     fovp24{i, 1} = idListp24(i);
%     fovp24{i, 2} = temp;
% end
% % total = [total3;total5;total7;total8;totalp22;totalp24;];