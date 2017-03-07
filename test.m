

%measures = {'GDER'};
measures = {'BREN'};

for i = 1:numel(measures)
    fovData = getFOVFocusData('/Volumes/DATA-2/Processed/20150619/', {'X20-FOV3-B'}, measures{i});
    save(['../data/' measures{i} '-testNewShouldBeSameAsVanilla'], 'fovData');
end 