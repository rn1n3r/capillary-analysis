
% % Defaults

% This is the path to the "Processed" folder, assuming that there is a
% corresponding "Captured" folder in the parent directory
processedFolder = '../capillary-data/Processed/';
%fovList = {'X20-FOV3-B', 'X20-FOV5-B', 'X20-FOV7-B', 'X20-FOV8-B', 'X20-FOVp2-2-B', 'X20-FOVp2-4-P'};
fovList = {'X20-FOV3-B'};
measures = {'BREN'};
%measures = {'TENG', 'TENV', 'VOLA' };

for i = 1:numel(measures)
    fovData = analyseFOVFocus('../capillary-data/Processed/', fovList, measures{i});
    save(['../capillary-data/data/' measures{i} '-01-13'], 'fovData');
end
