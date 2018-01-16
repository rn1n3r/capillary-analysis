load('/Users/edward/Documents/capillary-data/X20-FOV3-B-results.mat')
varImg = imread(['../capillary-data/Processed/X20-FOV3-B/Functional-16bitImages/X20-FOV3-B-16bit442Var.tif']);
capArea = getCapillaries(varImg);
ids = fovData.('X20FOV3B');

meanValues = zeros(520, length(ids));
for i = 1:length(ids)
    meanValues(:, i) = nanmean(ids{i,2},2);
end

meanValuesNorm = meanValues./max(meanValues(:));

for i = 1:100
    threshmap = threshMap(ids, capArea, i/100, false, meanValuesNorm);
    TPF(i) = sum(focusMask(threshmap == 1) == 1337)/sum(focusMask(:) == 1337);
    FPF(i) = sum(focusMask(threshmap == 1) == 9001)/sum(focusMask(:) == 1337);
    
end

plot(FPF, TPF);
aroc = -trapz(FPF, TPF);