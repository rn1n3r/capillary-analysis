% In focus
fovName = 'X20-FOV5-B';


if isunix
    %varImg = imread(['/Volumes/DATA-2/Processed/20150619/' fovName '/Functional-16bitImages/' fovName '-16bit442Var.tif']);
    varImg = imread(['../DATA-2/Processed\' fovName '\Functional-16bitImages\' fovName '-16bit442Var.tif']);
    area = getCapillaries(varImg);
    fov = fovData.(strrep(fovName, '-', ''));
    [aroc, TPF, FPF] = generateROC(fov, area, [1100 1100 2100 600 4100 3100], '/Volumes/DATA-2/Processed/20150619/X20-FOV3-B');
    %[aroc, TPF, FPF] = generateROC(fov, area, [4600 2600 3100 600], '/Volumes/DATA-2/Processed/20150619/X20-FOV5-B');

else
    varImg = imread(['..\DATA-2\Processed\' fovName '\Functional-16bitImages\' fovName '-16bit442Var.tif']);
    area = getCapillaries(varImg);
    fov = fovData.(strrep(fovName, '-', ''));
    %[aroc, TPF, FPF] = generateROC(fov, area, [1100 1100 2100 600 3600 3100], 'C:\Users\Edward\Documents\Files\DUROP\DATA-2\Processed\X20-FOV3-B\');
    [aroc, TPF, FPF] = generateROC(fov, area, [4600 1600 3600 600], 'C:\Users\Edward\Documents\Files\DUROP\DATA-2\Processed\X20-FOV5-B\');

end

