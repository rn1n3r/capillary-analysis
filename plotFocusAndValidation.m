%% Script to plot a given focus measure over the length of capillary, and also
%  overlay the in-focus area in green
figure;
fmeasureStr = {'LAPE'};
fovList = {'X20-FOV3-B','X20-FOV5-B', 'X20-FOV7-B', 'X20-FOV8-B', 'X20-FOVp-2-2-B', 'X20-FOVp-2-4-P'};
fovIndex = 1;

% Load validation data, capillary data
load(['/Users/edward/Documents/capillary-data/validate/' fovList{fovIndex} '-results.mat'])
varImg = imread(['../capillary-data/Processed/' fovList{fovIndex} '/Functional-16bitImages/' fovList{fovIndex} '-16bit442Var.tif']);
capArea = getCapillaries(varImg);

load(['/Users/edward/Documents/capillary-data/data/' fmeasureStr{1} '-all-05-15-middle.mat']);
    

% Set in-focus as 1, out of focus as 0
focusMask(focusMask == 1337) = 1;
focusMask(focusMask == 9001) = 0;

% Get the capillary IDs
ids = [fovData.(erase(fovList{fovIndex}, '-')){:,1}];

% Shade in the background as green for in-focus
for j = 1:length(ids)
    subplot(2,5,j)
    hold on
    
    index = find(capArea == ids(j));
    [y, ~] = ind2sub(size(capArea), index);
    
    [uniqueY, uniqueYindex] = unique(y);
    area(uniqueY, focusMask(index(uniqueYindex)), 'LineStyle', 'none', 'FaceColor', 'green');
    
end

% Plot the focus measure
for j = 1: length(fmeasureStr)
    
    
    load(['/Users/edward/Documents/capillary-data/data/' fmeasureStr{j} '-all-05-15-middle.mat']);
    
    plotFOVFocusNoCV(fovData.(erase(fovList{fovIndex}, '-')), [], true);
    hold on
    
end

legend(['In focus' fmeasureStr])



%%