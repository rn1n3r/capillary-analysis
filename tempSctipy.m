% In focus

varImg = imread('/Volumes/DATA-2/Processed/20150619/X20-FOV3-B/Functional-16bitImages/X20-FOV3-B-16bit442Var.tif');
area = getCapillaries(varImg);
inFocusMap = zeros(520, 696);
noFocusMap = inFocusMap;
load('/Users/edward/data/BREN-testMiddle.mat');
fov = fovData.('X20FOV3B');


load('/Volumes/DATA-2/Processed/20150619/X20-FOV3-B/VesselGeometry/1a442.mat');
ycoords = Capillary2nd.Coordinates(2) + (1:Capillary2nd.y2(end));
tempArea = area;
indices = area == 1100;

tempArea(ycoords, :) = 1;
inFocusMap(indices & tempArea == 1) = 1;


load('/Volumes/DATA-2/Processed/20150619/X20-FOV3-B/VesselGeometry/2a442.mat');
ycoords = Capillary2nd.Coordinates(2) + (1:Capillary2nd.y2(end));
tempArea = area;
indices = area == 2100;

tempArea(ycoords, :) = 1;
inFocusMap(indices & tempArea == 1) = 1;


load('/Volumes/DATA-2/Processed/20150619/X20-FOV3-B/VesselGeometry/3a442.mat');

ycoords = Capillary2nd.Coordinates(2) + (1:Capillary2nd.y2(end));
tempArea = area;
indices = area == 600;

tempArea(ycoords, :) = 1;
inFocusMap(indices & tempArea == 1) = 1;

load('/Volumes/DATA-2/Processed/20150619/X20-FOV3-B/VesselGeometry/4anif442.mat');

ycoords = Capillary2nd.Coordinates(2) + (1:Capillary2nd.y2(end));
tempArea = area;
indices = area == 4100;

tempArea(ycoords, :) = 1;
noFocusMap(indices & tempArea == 1) = 1;

load('/Volumes/DATA-2/Processed/20150619/X20-FOV3-B/VesselGeometry/5anif442.mat');

ycoords = Capillary2nd.Coordinates(2) + (1:Capillary2nd.y2(end));
tempArea = area;
indices = area == 3100;

tempArea(ycoords, :) = 1;
noFocusMap(indices & tempArea == 1) = 1;

load('/Volumes/DATA-2/Processed/20150619/X20-FOV3-B/VesselGeometry/1agmf442.mat');

ycoords = Capillary2nd.Coordinates(2) + (1:Capillary2nd.y2(end));
tempArea = area;
indices = area == 1100;

tempArea(ycoords, :) = 1;
noFocusMap(indices & tempArea == 1 & ~inFocusMap) = 1;



TPF = [];
FPF = [];

for i = 0:0.5:8

    threshmap = threshMap(fov, area, i, 'false');
    inFocusMap(area ~= 1100 & area ~= 600 & area ~= 3100 & area ~= 4100 & area ~= 2100) = 22;
    

    TPF = [TPF sum(inFocusMap(threshmap == 1) == 1)/sum(sum(inFocusMap == 1))];
    FPF = [FPF sum(noFocusMap(threshmap == 1) == 1)/sum(sum(noFocusMap == 1))];
end

plot(0:0.1:1, 0:0.1:1);
hold on;
plot(FPF, TPF);
