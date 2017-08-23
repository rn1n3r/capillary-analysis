% Function to generate ROC based off of the focus labels in the ORIGINAL
% DATA
% Uses the VesselGeometry directory of processed data for the FOV 
% idWithTruthList is the list capillary IDs with a corresponding capillary
% in the VesselGeometry data -- this needs to be in the same alphabetical
% or

function [aroc, TPF, FPF] = generateROC(fov, capMask, idWithTruthList, FOVProcesseddir)
    
    % Initialize variables for the marked focus/not in focus maps
    inFocusMap = zeros(520, 696);
    noFocusMap = inFocusMap;
    
    
    % Get list of all 442 vessel geometry .mat files from the Processed
    % folder
    matList = dir([FOVProcesseddir '/VesselGeometry/*.mat']);
    matList = {matList.name};
    counter = 1;
    for i = 1: length(matList)
        if ~isempty(strfind(matList{i}, '442'))
            % Load the vessel geometry file and get the ycoordinates
            load([FOVProcesseddir '/VesselGeometry/' matList{i}]);
            ycoords = Capillary2nd.Coordinates(2) + (1:Capillary2nd.y2(end));
            
            % Create mask of only the intersection of the vessel geometry
            % area and the detected capillary area
            tempArea = false(520,696);
            tempArea(ycoords,:) = capMask(ycoords,:) == idWithTruthList(counter);
            
            % Mark this area as in-focus or not in focus
            if isempty(strfind(matList{i}, 'anif')) && isempty(strfind(matList{i}, 'agmf'))
                inFocusMap(tempArea) = 1;
            else
                noFocusMap(tempArea & ~inFocusMap) = 1;
            end
            counter = counter + 1;
        end
    end
    
    nThresholds = 20;
    TPF = zeros(nThresholds, 1);
    FPF = zeros(nThresholds, 1);
    
    % Loop through all the capillary ids and create a mask that represents
    % the area that is not covered by any of the detected capillaries
    tempAreaMask = capMask ~= idWithTruthList(1);
    for i = 2:length(idWithTruthList)
        tempAreaMask = tempAreaMask & capMask ~= idWithTruthList(i);
    end
    inFocusMap(tempAreaMask) = 22;
    
    % Get histogram info
    [hist, edges] = generateHistogram(fov, true);
    cutoff = findMostValuesHist(hist, edges);
    
    
    
    meanValues = zeros(520, length(fov));
    for i = 1:length(fov)
       meanValues(:, i) = nanmean(fov{i,2},2); 
    end
    
    
    thresholdRange = [linspace(0, cutoff, nThresholds) max(meanValues(:))];
    for i = 1:length(thresholdRange)

        threshmap = threshMap(fov, meanValues, capMask, thresholdRange(i), false);
        
        TPF(i) = sum(inFocusMap(threshmap == 1) == 1)/sum(inFocusMap(:) == 1);
        FPF(i) = sum(noFocusMap(threshmap == 1) == 1)/sum(noFocusMap(:) == 1);
    end

    hold on;
    plot(FPF, TPF);


    aroc = -trapz(FPF, TPF);
   
end
