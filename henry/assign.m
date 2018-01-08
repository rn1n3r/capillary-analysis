% The purpose of this function is to test a detection range of interest,
% namely frames 302 to 330 to solve a particular bug, in this case is the
% bug where two assignments randomly swap and then swap back. Needs to load
% a cell array of detections. Depends on Munkres, eucDistance, missingFix.
% Saves resulting assignments as a mat file named according to the date.
% Basically a mini version of assign.m

% for i = 1:29
%    
%     j = 301 + i;
%     detectionsOfInterest{i} = detections{j}(:,1:2);
%     
% end


function assignment = assign(handles, detections)

% detections is a cell array, with an array corresponding to each frame.
% Each array contains an x column, y column, and finally an intensity value
% in the third column. 

% Deal with first frame first


% load('/Users/henry/Desktop/StraightCap2/Processed/20150619/X20-FOVp2-4-P/HENRYMOT/detections.mat')
% capturedDir = '/Users/henry/Desktop/StraightCap2/Captured/20150619/442/X20-FOVp2-4-P/1a/cropped images';
% img_list = dir(fullfile(capturedDir, '*.png'));

capturedDir = handles.croppedDir;
img_list = handles.img_list;


% FIRST FRAME CASE
firstFrame = 1;
first = detections{firstFrame};
first = first(:,1:2); % discard the intensity for now. 
prev = first; % first is the first prev.
assignment = cell(size(detections,1),1);
assignment{firstFrame} = [flipud((1:size(first,1))') first];
idfirst = 1;

birthFlag = false; % for assignin purposes
delFlag = false;
assn = 0;
thrownOut = []; 

% CONSTANTS
birthThresh = 10;
deathThresh = 165;
birthPointOfFrame = 1;
deathPointOfFrame = 171;
RBCLength = 15;
testStart = 0;

% LOOP

for i = firstFrame + 1:size(detections,1)

    

    % DEBUG CHECKS
%     assignin('base', 'assignment', assignment) 
%     assignin('base', 'i', testStart+i);
%     assignin('base', 'idfirst', idfirst);
%     assignin('base', 'prev', prev)
%     assignin('base', 'birthFlag', birthFlag);
%     assignin('base', 'delFlag', delFlag);
%     assignin('base', 'assn', assn);
    
    cur = detections{i};
    birthFlag = false; % reset each round
    delFlag = false;
    theMissingOne = 0;
    targetSize = 0;
    
    prevframe = imread(fullfile(capturedDir, img_list(i-1).name));
    curframe = imread(fullfile(capturedDir, img_list(i).name));
    intensityConstLow = 10000;
    specCaseConst = 5.5;
    
%     if i == 561
%         waitforbuttonpress;
%     end
    
    % CHECK 1: Current frame is not empty, has detections before retrieving
    % them
    if ~isempty(cur)
        cur = cur(:,1:2);
    end
    
%     assignin('base', 'cur', cur)
    
    
    % CHECK 2: Both frames are non-empty. See if there are any deletions or
    % births and raise flags if there are.
    
    if ~isempty(prev) && ~isempty(cur)
                
        if size(prev,1) > 1 % will not have deaths with nonempty cur and size of 1 prev
        
            % DEL CASE 1: 
            % If bottom most cell of cur is higher than bottom most cell of prev, 
            % AND previous bottom-most cell was in death zone, then a cell has 
            % likely been deleted (downward flow). 
            % Assume at most 1 cell gets deleted per frame.
            if cur(end,2) < prev(end,2) && prev(end,2) >= deathThresh
                delFlag = true;
                

            % DEL CASE 2: If two bottom most cells of cur and prev are both at the bottom of the
            % frame
            % Check if in the previous frame the last two detections were
            % too close to be separate RBCs. Compare the 3rd last of prev and second last of cur. If they are closer than the
            % RBC length constant, then assume the cur detection is the 
            % second last RBC and the last one was deleted. Needs to be a
            % separate case because need to check if prev has more than one
            % cell (this would probably never occur if there was only one cell in
            % the frame). 
            elseif cur(end,2) == deathPointOfFrame && prev(end,2) == deathPointOfFrame ...
                    && eucDistance(prev(end-1,:), cur(end, :)) <= RBCLength % there is a deletion, not a missing detection

                delFlag = true;
                
               
            end
        end
        
        %Frame 1157 constant: start at 1 then 2 then back up to 1
        % frame825constant = 20;
        % second half of condition is for frames 825 and 1079 edge case
        % when both first centroids are y = 1.
        
        if size(cur,1) > 1   
  
            % BIRTH CASE 1: If cur top-most cell is higher than prev top-most
            % cell 
            if cur(1,2) < prev(1,2) && cur(1,2) <= birthThresh ...
                    && eucDistance(prev(1,:), cur(1,:)) >= RBCLength/5 % birth one track, assuming at the top
                
                %all I want to do is account for noise when the same cell
                %at the top of the frame doesn't move but centroid
                %detection goes from 3 to 1 (don't want a new birth)
                
                birthFlag = true;

            % BIRTH CASE 2: If both cur and prev top-most cells are at the
            % top of frame and it's not just the cell moving too slowly
            elseif cur(1,2) == birthPointOfFrame && prev(1,2) == birthPointOfFrame ...
                    && eucDistance(cur(1,:), cur(2,:)) > RBCLength/2 ...
                    && eucDistance(cur(1,:), cur(2,:)) < 1.5*RBCLength ...
                    && cur(2,2) < 1.25*RBCLength
                
                birthFlag = true;
                
            end
        end
    end
        
    %special case when rbcs are speedy
    if eucDistance(cur(end,:), prev(end,:)) <= specCaseConst ...
        && (size(cur,1) < size(prev,1) || (size(cur,1) == size(prev,1) && birthFlag == true) ) ...
        && range(prevframe(165,:)) >= intensityConstLow

        delFlag = true;
    end
    
    if eucDistance(cur(1,:), prev(1,:)) <= specCaseConst ...
            && (size(cur,1) > size(prev,1) || (size(cur,1) == size(prev,1) && delFlag == true) ) ...
            && range(prevframe(1,:)) >= intensityConstLow
        birthFlag = true;
    end
    
    
%     if i == 479
%         waitforbuttonpress;
%     end
    
    
    % EMPTY CASE 1: Cur is empty and Prev is not (assuming 1 detection, if
    % only 1 RBC gets deleted per frame!
    if isempty(cur) && size(prev,1) == 1 
        idfirst = idfirst + 1; 
        assignment{i} = [];
    % EMPTY CASE 2: Both cur and prev are empty! 
    elseif isempty(cur) && isempty(prev) % empty and prev frame was empty
        assignment{i} = [];
    % EMPTY CASE 3: Prev is empty and cur is not 
    elseif isempty(prev) && size(cur,1) == 1 
        assignment{i} = [idfirst cur]; % Make new track
    
    % SIZE CASE 1: Equal sizes. Either normal assignment or 1 birth + missing detection or 1 birth + 1
    % death or 1 death + extra detection
    elseif size(cur, 1) == size(prev,1)         
        
        % SIZE CASE 1a: 1 birth and 1 death
        if birthFlag == true 
            if delFlag == true
                
                %delCode
                [prev, idfirst] = delCode(prev,idfirst, thrownOut); 

                %birthCode
                assn = birthCode(prev, cur);

            % SIZE CASE 1b: 1 birth and 1 missing detection    
            else 
                % missingFix code
                [assn, cost] = munkres(pdist2(prev, cur));
                targetSize = size(prev,1) + 1; % prev plus birth
                [cur, prev, theMissingOne] = missingFix(i+testStart, cur, prev, assn, targetSize);
                
               % birth code
                assn = birthCode(prev, cur);
                
            end
        else
            
            % SIZE CASE 1c: 1 death and 1 extra detection
            if delFlag == true
                    
                % del code
                [prev, idfirst] = delCode(prev,idfirst, thrownOut); 
                
                %extrafix
                cur = extraFix(cur, prev, birthFlag);
                
                [assn, cost] = munkres(pdist2(prev, cur)); % then we assign
                
             
            % SIZE CASE 1d: no death and no birth
            else
                % normal assignment
                [assn, cost] = munkres(pdist2(prev, cur));
               
            end
        end

        assn = finalAssnCode(assn, idfirst, thrownOut);
    
         % if missingFix ended prematurely for missing track, need
        % to update assn numbering to skip that track id. 
        if theMissingOne ~= 0
            if birthFlag == 1
               theMissingOne = theMissingOne + 1;  
            end
            theMissingOne = targetSize + 1 - theMissingOne;
            assn(theMissingOne:end) = assn(theMissingOne:end) + 1;
            thrownOut = [thrownOut idfirst + theMissingOne - 1];
        end
        
        try
            assignment{i} = [flipud(assn') cur]; 
        catch
            assignment{i} = [];
            thrownOut = [thrownOut assn];
        end
        
        % SIZE CASE 2: Missing tracks. Either deletions or missing detections. 
    % Or birth and deletion and missing detection?     
    elseif size(cur,1) < size(prev,1) 

        if delFlag == true          
            % SIZE CASE 2a: Death and birth with at least 1 missing
            % detection
            if birthFlag == true
                
                % del code
                [prev, idfirst] = delCode(prev,idfirst, thrownOut); 
                
                [assn, cost] = munkres(pdist2(prev, cur));
                 
                % missingFix code
                targetSize = size(prev,1) + 1;
                [cur, prev, theMissingOne] = missingFix(i+testStart, cur, prev, assn, targetSize);
                
                
                % birth code
                assn = birthCode(prev, cur);
               
            
            % SIZE CASE 2b: Deletion w/o birth, regular deletion with
            % potential missing detections
            else
                % del code
               [prev, idfirst] = delCode(prev,idfirst, thrownOut); 
               
                [assn, cost] = munkres(pdist2(prev, cur));
                
                % missingFix code
                targetSize = size(prev,1);
                [cur, prev, theMissingOne] = missingFix(i+testStart, cur, prev, assn, targetSize);
                [assn, cost] = munkres(pdist2(prev, cur)); % then we assign
              
            end
        else
            % SIZE CASE 2c: Birth and 2+ disappearances
            if birthFlag == true
                    
                % birth code
                assn = birthCode(prev, cur);         
                
                % missingFix code
                [assn, cost] = munkres(pdist2(prev, cur)); % then we assign
                targetSize = size(prev,1) + 1;
                [cur, prev, theMissingOne] = missingFix(i+testStart, cur, prev, assn, targetSize);
                [assn, cost] = munkres(pdist2(prev, cur)); % then we assign
                
                
            % SIZE CASE 2d: Just missing detection(s)    
            else
                [assn, cost] = munkres(pdist2(prev, cur)); % then we assign

                % missingFix code
                targetSize = size(prev,1);
                [cur, prev, theMissingOne] = missingFix(i+testStart, cur, prev, assn, targetSize);
                [assn, cost] = munkres(pdist2(prev, cur)); % then we assign
              
               
            end
                        
        end
        
        assn = finalAssnCode(assn, idfirst, thrownOut);

         % if missingFix ended prematurely for missing track, need
        % to update assn numbering to skip that track id. 
        if theMissingOne ~= 0
            if birthFlag == 1
               theMissingOne = theMissingOne + 1;  
            end
            theMissingOne = targetSize + 1 - theMissingOne;
            assn(theMissingOne:end) = assn(theMissingOne:end) + 1;
            thrownOut = [thrownOut idfirst + theMissingOne - 1];
        end
        
        try
            assignment{i} = [flipud(assn') cur]; 
        catch
            assignment{i} = [];
            thrownOut = [thrownOut assn];
        end
           
    elseif size(cur,1) > size(prev,1) % more detections

        if delFlag == true
            % SIZE CASE 3a: birth and death and then 1+ extra detections
            if birthFlag == true
            
                % death code
                [prev, idfirst] = delCode(prev,idfirst, thrownOut);
                
                cur = extraFix(cur, prev, birthFlag);
                
                % birth code
                assn = birthCode(prev, cur);
               
                
            % SIZE CASE 3b: death and 2+ extra detections
            else
 
                % del code
                [prev, idfirst] = delCode(prev,idfirst, thrownOut);
                
                cur = extraFix(cur, prev, birthFlag);
                
                [assn, cost] = munkres(pdist2(prev, cur)); % then we assign

            end
        else
            % SIZE CASE 3c: birth & potential extra detections
            if birthFlag == true
               

                 if size(cur,1) > size(prev,1) + 1 % still bigger means extra detections
                     %extra detections code
                     cur = extraFix(cur, prev, birthFlag);
                     assn = birthCode(prev,cur);
                    
                 else %extra detections beyond the birth
                     % birth code
                    assn = birthCode(prev, cur);
                 end
                
                
            % SIZE CASE 3d: no birth and no deaths, just extra detections    
            else
                
                % extra detections code
                cur = extraFix(cur, prev, birthFlag);
                
                [assn, cost] = munkres(pdist2(prev, cur)); 
%                 cur = cur(assn,:); % just assn and assume munkres is correct
%                 
                
            end
        end
        
        assn = finalAssnCode(assn, idfirst, thrownOut);
        
        try
            assignment{i} = [flipud(assn') cur]; 
        catch
            assignment{i} = [];
            thrownOut = [thrownOut assn];
        end
        
       
               
    end
    

    prev = cur;

    save(fullfile(handles.processedDir, 'HENRYMOT', 'assignment.mat'), 'assignment');
   
end




end

function [prev, idfirst] = delCode(prev,idfirst, thrownOut)
     % del code
    prev(end,:) = [];
    if any(arrayfun(@(x)any(idfirst == x), thrownOut)) % deleting a thrown out track
        idfirst = idfirst + 2;
    else
        idfirst = idfirst + 1; % real deletion, so add one to counter
    end
end

function assn = birthCode(prev, cur)
                
    % birth code
    tempCur = cur;
    tempCur(1,:) = []; 
    [assn, cost] = munkres(pdist2(prev, tempCur));
    assn = assn + 1;
%     if any(assn == 1) % edge case when assignment matches prev birth to new birth
%         assn(assn == 1) = 2;
%     end
    assn = [1, assn];
        
end

function assn = finalAssnCode(assn, idfirst, thrownOut)
   
       % assignment code
        assn = sort(assn);
        assn = idfirst + assn - 1;

        % get the indices of any elements of thrownOut in assn and increase
        % id by one for the ones that are thrown out... 
        idx = arrayfun(@(x)any(assn==x),thrownOut);
        idx = thrownOut(idx);
        idx = arrayfun(@(x)find(assn==x), idx);
        for j=1:length(idx)
            assn(idx(j):end) = assn(idx(j):end) + 1;
        end
        
    
end