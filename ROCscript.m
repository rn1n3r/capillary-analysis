% In focus

if isunix
    varImg = imread('/Volumes/DATA-2/Processed/20150619/X20-FOV3-B/Functional-16bitImages/X20-FOV3-B-16bit442Var.tif');
    %load('/Users/edward/data/BREN-testMiddle.mat');
    area = getCapillaries(varImg);
    fov = fovData.('X20FOV3B');
    [aroc, TPF, FPF] = generateROC(fov, area, [1100 1100 2100 600 4100 3100], '/Volumes/DATA-2/Processed/20150619/X20-FOV3-B')

else
    varImg = imread('..\DATA-2\Processed\X20-FOV3-B\Functional-16bitImages\X20-FOV3-B-16bit442Var.tif');
    %load('..\DATA-2\Processed\X20-FOV3-B\BREN-testMiddle.mat');
    area = getCapillaries(varImg);
    fov = fovData.('X20FOV3B');
    [aroc, TPF, FPF] = generateROC(fov, area, [1100 1100 2100 600 4100 3100], 'C:\Users\Edward\Documents\Files\DUROP\DATA-2\Processed\X20-FOV3-B\')
end


