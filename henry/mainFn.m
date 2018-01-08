handles = struct;

handles.mainDir = uigetdir(); % select the folder with experment name i.e. "X20..."
capName = '1a';


%% initializeFunction from preprocessing

% if a folder exists, set that file as source. Otherwise, make a new one and move all pngs
% to it.
if exist(fullfile( handles.mainDir, 'full images'),'dir') == 7
   ogDir = fullfile(handles.mainDir, 'full images');

   % load those images
    fileNames = dir(fullfile( ogDir, '*.png'));
    fileNames1 = { fileNames.name}'; %only for passing into functions!
    totalFrames = size( fileNames, 1);
else

    %set all pngs to fileNames
     fileNames = dir(fullfile( handles.mainDir, '*.png'));
     fileNames1 = { fileNames.name}'; %only for passing into functions!
     totalFrames = size( fileNames, 1);

     mkdir( handles.mainDir, 'full images');
     ogDir = fullfile( handles.mainDir, 'full images');

    %move files
    tic
    h = waitbar(0,'Moving Image Files',...
                'CreateCancelBtn',...
                'setappdata(gcbf,''canceling'',1)');
    setappdata(h,'canceling',0)

    for i=1: totalFrames
        if getappdata(h,'canceling')
            break
        end
        movefile(fullfile( handles.mainDir,  fileNames(i).name),  ogDir);

        if mod(i, 5) == 0
            waitbar(i/ totalFrames);
        end
    end
    delete(h);
    toc
end


%% load predetermined crop mtx from vessel geometry folder and make cropped folder with images
% (preprocessing > MyThirdGUI)


cropCoordName = fullfile(strrep(handles.mainDir, 'Captured', 'Processed'), 'VesselGeometry',...
    strcat(capName, '442.mat'));
cropCoordName = strrep(cropCoordName, '442/', '');
cropCoordName = strrep(cropCoordName, '454/', '');

load(cropCoordName);
cropMatrix = Capillary2nd.Coordinates;

%check to see if the folder exists
if ~(exist(fullfile(handles.mainDir, capName),'dir') == 7)
    mkdir(handles.mainDir, capName);
end

capDir = fullfile(handles.mainDir, capName);

%save this matrix just in case
save(fullfile(capDir, 'cropmtx.mat'), 'cropMatrix');


%% capCrop function in preprocessing

imageNames =  fileNames1;
frames =  totalFrames;

croppedFolder = 'cropped images';


% imageNames = dir(fullfile(handles.mainDir,'*.png'));
% frames = length(imageNames);
% imageNames = {imageNames.name}';

%only make the new folder and crop if it doesn't already exist
if exist(fullfile(capDir, croppedFolder),'dir') == 7
   button = questdlg([capName ' cropped folder already exists! Would you like to overwrite and recrop?']);
   if strcmp(button, 'Yes')
        % remove all files to get rid of weird stuff
        delete([fullfile(capDir, croppedFolder) '/*.png']);
        rmdir(fullfile(capDir, croppedFolder));
   end
else
   button = 'Yes'; 
end

if strcmp(button, 'Yes')
    tic
    
    mkdir(capDir, croppedFolder)
    
    h = waitbar(0,'Cropping Files',...
                'CreateCancelBtn',...
                'setappdata(gcbf,''canceling'',1)');
    setappdata(h,'canceling',0)

    for i=1:frames
        if getappdata(h,'canceling')
            break
        end
        curfilename = imageNames{i};
        img = imread(fullfile(ogDir, curfilename));

        img = imcrop(img, cropMatrix); %[xmin ymin width height]

    %     filename = [sprintf('%04d',i) '.png'];
        fullname = fullfile(capDir,croppedFolder,imageNames{i});

        imwrite(img,fullname);    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)

        if mod(i, 5) == 0
            waitbar(i/frames);
        end

    end
    delete(h);
    toc
end

handles.croppedDir = fullfile( capDir, 'cropped images');
handles.img_list = dir(fullfile(handles.croppedDir, '*.png'));


%% apply LoG filter and generate detections (1 and 2)

handles.hsizeh = 15;
handles.sigmah = 15;
handles.threshold = 0.3;
handles.closeExtrema = 8;

handles.processedDir = fullfile(strrep(handles.mainDir, 'Captured', 'Processed'));
handles.processedDir = strrep(handles.processedDir, '442/', '');
handles.processedDir = strrep(handles.processedDir, '454/', '');
[~, handles.expName,~] = fileparts(handles.processedDir);


hsizeh = handles.hsizeh;
sigmah = handles.sigmah;
threshold = handles.threshold;
closeExtrema = handles.closeExtrema;

mkdir(fullfile(handles.processedDir, 'HENRYMOT'));
save(fullfile(handles.processedDir, 'HENRYMOT', 'logparams.mat'), 'hsizeh', 'sigmah', 'threshold', 'closeExtrema');



if exist(fullfile(handles.processedDir, 'HENRYMOT', 'detections.mat'), 'file') == 2
    choice = questdlg('detections.mat already exists. Overwrite?','Confirmation', 'Yes', 'No', 'No');

    switch choice
        case 'Yes'
            detections = detect(handles);
        case 'No'
            load(fullfile(handles.processedDir, 'HENRYMOT', 'detections.mat'));
    end

else
    detections = detect(handles);

end




%% assign

assignment = assign(handles, detections);

%% velocity analysis - assignment

finaltracks = cell(size(assignment,1),1);

%rearrange from per frame to per track id.
for i= 1:size(assignment,1)
   
    frame = assignment{i};
    for j=1:size(frame,1)
       finaltracks{frame(j,1)}(end + 1,:) = [i frame(j, 2:3)];
    end
end

finaltracks = finaltracks(~cellfun('isempty',finaltracks)); % remove empty cell array contents

% calculate velocities
velocities = velocityCalculator(finaltracks);

%% Visualize and Compare Avg Velocities per Frame

% reorganize vels per track to avg velocities per frame 

%clean up velocities file first, take out empty cells for example from a
% single track at the beginning or end of the video for ex
meanVelsPerFrame = rearrangeData(velocities);


%% GOLDSTD
load(fullfile(handles.processedDir, 'Gold Standards', strcat(capName, '_goldstd.mat')));
numTracks = tracks(end).pos(end,1);
finaltracks = cell(numTracks,1);

%rearrange from per frame to per track id.
for i= 1:size(tracks,2)
   
    frame = tracks(i).pos;
    if ~all(isnan(frame)) % only for non empty frames (check to see if it's all nan)
        
        for j=1:size(frame,1) 
           finaltracks{frame(j,1)}(end + 1,:) = [i frame(j, 2:3)];
        end
    else
        finaltracks{frame(j,1)}(end + 1,:) = [i [NaN, NaN]]; % set that frame to NaN if the frame is empty
    end
end

finaltracks = finaltracks(~cellfun('isempty',finaltracks)); % remove empty cell array contents

goldVelocities = velocityCalculator(finaltracks);

meanVelsPerFrameGold = rearrangeData(goldVelocities);

% assignin('base', 'tracks', finaltracks);
% save(fullfile(dirr, 'goldstdFinaltracks.mat'), 'finaltracks')

%% STI Velocities

stiVelName = strcat(handles.expName, '-', capName, '_All_Results.mat'); 
load(fullfile(handles.processedDir, 'Data', stiVelName));
meanVelsPerFrameSTI = RBC_Velocity.Velocities;



%% Plotting

subplot(4,1,1)
plot(meanVelsPerFrame)
title('LoG Mean Velocity Per Frame')
xlabel('Frame');
ylabel('Avg Velocity (microns/s)');

subplot(4,1,2)
plot(meanVelsPerFrameGold)
title('Goldstd Avg Velocity Per Frame')
xlabel('Frame');
ylabel('Avg Velocity (microns/s)');

subplot(4,1,3)
plot(meanVelsPerFrameSTI)
title('STI Avg Velocity Per Frame')
xlabel('Frame');
ylabel('Avg Velocity (microns/s)');

diffVels = abs(meanVelsPerFrame - meanVelsPerFrameGold);

% find the frames with avg velocities greater than 10% of avg velocity,
% print them
avgFPS = 20.67;
magPxConstant = 0.66189;
secPerFrame = 1/avgFPS; 

% an error of 1 pixel, in microns/s
measurementError = magPxConstant / secPerFrame;
framesOfInterest = find(diffVels >= measurementError);
length(framesOfInterest)


subplot(4,1,4)
plot(diffVels)
title('Diff b/w Avg Velocities Per Frame LoG - Gold')
xlabel('Frame');
ylabel('Avg Velocity (microns/s)');



colorCorrelFigName = strcat(handles.expName, capName, 'VelocityNewClean.fig');
openfig(fullfile(handles.processedDir, 'O2TransportFigures', colorCorrelFigName));


% Assign Visualizer Verify

% Throw out tracks with velocities over 300 microns/s & COUNT how many were
% thrown out

% Compare to goldstd average velocities per frame
% Compare to STI velocities
% compare to color correlegram - "O2TransportFigures - VelocityNewClean