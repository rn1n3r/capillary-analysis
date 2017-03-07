% Gets the fmeasures of all capillaries in the FOV (from fname)
% Make sure to start parallel processing pool!
function fov = getFOVfmeasures(measure, var, fname, maxImg)
    
    % Get the capillary IDs in the FOV
    [~, idList] = getCapillaries(var);

    fov = cell(size(idList, 1), 2);
    fov(:, 1) = num2cell(idList(:, 1));
    [fov{:, 2}] = deal(zeros(520, 1260));
   
    area = getCapillaries(var);
    
    % This 520 x 1260 x #capillaries matrix is needed to get around the
    % indexing problems from using parfor
    tempMatrix = zeros(520, 1260, size(idList, 1));
  
    parfor i = 1:size(fname, 1)
        listFM = zeros(520, size(idList, 1));
        frame = imread(fname{i});
        % FIRST, REMOVE THE BACKGROUND USING THE MAX IMAGE FROM THE ENTIRE
        % VIDEO
        % Yeah, I know it's not actually removing it since this "background"
        % fluctuates but it's a lot better than nothing
        % Then edge detect to get cell borders
        edgeFrame = edge(maxImg - frame, 'canny', 0.26);
       
        % For each capillary detected, find all the RBCs
        for j = 1:size(idList, 1)
            [listROI, circ] = findRBC(edgeFrame, area, idList(j, 1));
            fm = zeros(size(listROI, 1), 1);
            
            % Take the focus measure of each RBC
            for k = 1:size(fm, 1)        
                fm(k) = fmeasure(frame, measure, listROI(k, :));

                % Normalize by background intensity
                fm(k) = fm(k)/mean2(imcrop(maxImg, listROI(k, :)));
            end

            % Normalize by RBC circumference
            fm = fm./circ;

            % In the case that there are NO RBCs found in the path
            if ~isempty(fm)
                for k = 1:numel(fm)
%                     ycoord = listROI(k, 2) + floor(listROI(k,4)/2);
%                     if ycoord > 520
%                         ycoord = 520;
%                     end
                    ycoord = listROI(k, 2);
                    listFM(ycoord, j) = fm(k);
                end
            end
            
            tempMatrix(:, i, :) = listFM;
        end    
    end
    
    % NaN out the places where there no cells (or perhaps focus measure was
    % 0?)
    tempMatrix(tempMatrix == 0) = NaN;
    
    % Store the values from the tempMatrix into the fov cell
    for i = 1:size(idList, 1)
        fov{i, 2} = tempMatrix(:, :, i);
    end
    
end
