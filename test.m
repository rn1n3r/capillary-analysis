
measures = {'ACMO', 'BREN', 'CONT'};

for i = 1:numel(measures)
    fovData = getFOVFocusData('/Volumes/DATA-2/Processed/20150619/', {'X20-FOV3-B', 'X20-FOV5-B', 'X20-FOV7-B', 'X20-FOV8-B', 'X20-FOVp2-2-B', 'X20-FOVp2-4-P'}, measures{i});
    save(['../data/' measures{i}], 'fovData');
end