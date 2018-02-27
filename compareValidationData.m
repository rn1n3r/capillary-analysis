%clean
%fovList = {'X20-FOV3-B','X20-FOV5-B', 'X20-FOV7-B', 'X20-FOV8-B', 'X20-FOVp2-2-B', 'X20-FOVp2-4-P'};
fovList = {'X20-FOVp2-2-B'};
%fmeasureFile = 'BREN-all-02-13.mat';
fmeasureFile = 'TENV-all-02-13.mat';
aroc = zeros(length(fovList), 1);
figure
for j = 1:length(fovList)
   % subplot(2,3,j);
fovString = fovList{j};
      
load(['/Users/edward/Documents/capillary-data/validate/' fovString '-results.mat'])
load(['/Users/edward/Documents/capillary-data/data/' fmeasureFile])

varImg = imread(['../capillary-data/Processed/' fovString '/Functional-16bitImages/' fovString '-16bit442Var.tif']);
capArea = getCapillaries(varImg);
ids = fovData.(erase(fovString, '-'));

meanValues = zeros(520, length(ids));
for i = 1:length(ids)
    meanValues(:, i) = nanmean(ids{i,2},2);
end

meanValuesNorm = meanValues./max(meanValues(:));

focusMask(focusMask(capArea == 1) == 0) = 9001;

for i = 0:100
    threshmap = threshMap(ids, capArea, i/100, false, meanValuesNorm);
    imshow(threshmap, []);
    title(i)
    
    %if i == 0
    %    threshmap(:) = 1;
    %end
    TPF(i+1) = sum(focusMask(threshmap == 1) == 1337)/sum(focusMask(:) == 1337);
    FPF(i+1) = sum(focusMask(threshmap == 1) == 9001)/sum(focusMask(:) == 9001);
    pause
end



plot(FPF, TPF);
title(fovString);

aroc(j) = -trapz(FPF, TPF);
xlabel(aroc(j));

end

