
% % Defaults

% This is the path to the "Processed" folder, assuming that there is a
% corresponding "Captured" folder in the parent directory
processedFolder = '../DATA-2/Processed/';
fovList = {'X20-FOV3-B', 'X20-FOV5-B', 'X20-FOV7-B', 'X20-FOV8-B', 'X20-FOVp2-2-B', 'X20-FOVp2-4-P'};

measures = {'BREN', 'CONT', 'GDER' };

for i = 1:numel(measures)
    fovData = analyseFOVFocus('../DATA-2/Processed/', fovList, measures{i});
    save(['../data/' measures{i} '-06-28'], 'fovData');
end
