
% % Defaults
% mainPath = '/Volumes/DATA-2/Captured/20150619/';
% fovList = {'X20-FOV3-B', 'X20-FOV5-B', 'X20-FOV7-B', 'X20-FOV8-B', 'X20-FOVp2-2-B', 'X20-FOVp2-4-P'};

%measures = {'GDER'};
measures = {'CONT'};

if ispc
    for i = 1:numel(measures)
        fovData = getFOVFocusData('../DATA-2/Processed/', {'X20-FOV3-B'}, measures{i});
        save(['../data/' measures{i} '-FOV3-onPC'], 'fovData');
    end
else
    
    for i = 1:numel(measures)
        fovData = getFOVFocusData('/Volumes/DATA-2/Processed/20150619/', {'X20-FOV3-B'}, measures{i});
        save(['../data/' measures{i} '-testNewShouldBeSameAsVanilla'], 'fovData');
    end 

end