function [aroc, TPF, FPF] = generateROC(fov, area, idWithTruthList, FOVdir)

    inFocusMap = zeros(520, 696);
    noFocusMap = inFocusMap;
    % Get list of all 442 vessel geometry .mat files from the Processed
    % folder
    
    
    matList = dir([FOVdir '\VesselGeometry\*.mat']);
    counter = 1;
    for i = 1: length(matList)
        if ~isempty(strfind(matList(i).name, '442'))
            load([FOVdir '\VesselGeometry\' matList(i).name]);
            ycoords = Capillary2nd.Coordinates(2) + (1:Capillary2nd.y2(end));
            tempArea = area;
            indices = area == idWithTruthList(counter);
            tempArea(ycoords, :) = 1;
            
            % In focus capillaries
            if isempty(strfind(matList(i).name, 'anif')) && isempty(strfind(matList(i).name, 'agmf'))
                inFocusMap(indices & tempArea == 1) = 1;
              
            else
                noFocusMap(indices & tempArea == 1  & ~inFocusMap) = 1;
            end
            counter = counter + 1;
        end
    end
    
    TPF = [];
    FPF = [];

    for i = 0:0.5:14

        threshmap = threshMap(fov, area, i, false);
        inFocusMap(area ~= 1100 & area ~= 600 & area ~= 3100 & area ~= 4100 & area ~= 2100) = 22;


        TPF = [TPF sum(inFocusMap(threshmap == 1) == 1)/sum(sum(inFocusMap == 1))];
        FPF = [FPF sum(noFocusMap(threshmap == 1) == 1)/sum(sum(noFocusMap == 1))];
    end

    plot(0:0.1:1, 0:0.1:1);
    hold on;
    plot(FPF, TPF);
   
    

    aroc = -trapz(FPF, TPF);
   
end

%[aroc, TPF, FPF] = generateROC(fov, area, [1100 1100 2100 600 4100 3100], 'C:\Users\Edward\Documents\Files\DUROP\DATA-2\Processed\X20-FOV3-B\')