
% % Defaults

% This is the path to the "Processed" folder, assuming that there is a
% corresponding "Captured" folder in the parent directory
%processedFolder = '../capillary-data/Processed/';
%processedFolder = '/Volumes/My Passport/backup-0825/Edward/Documents/Files/DUROP/DATA-2/Processed/';
processedFolder = '/Volumes/DATA-2/Processed/20150619/';
fovList = {'X20-FOV3-B','X20-FOV5-B', 'X20-FOV7-B', 'X20-FOV8-B', 'X20-FOVp2-2-B', 'X20-FOVp2-4-P'};
%measures = {};

measures = {'LAPE', 'LAPM', 'LAPV', 'LAPD'};

for i = 1:numel(measures)
    fovData = analyseFOVFocus(processedFolder, fovList, measures{i});
    save(['../capillary-data/data/' measures{i} '-all-05-15-middle'], 'fovData');
end
