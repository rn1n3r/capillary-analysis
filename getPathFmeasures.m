% Try and find the subregion in a capillary path that is in-focus
% Returns all values of the specified focus measures at all y-coordinates
% throughout the 1260 frames
%
% The range is 1 - 520, so if there is no capillary then the value is NaN
%
% This function only does one capillary to make parallel processing easier
% in getFOVfmeasures.m

function listFM = getPathFmeasures (fname, var, id, fmStr, maxImg)

    area = getCapillaries(var);
    
    % Store the max/min/avg fm, last column used to store number of RBCs
    % detected at that y-coordinate
        
    listFM = zeros(520, 1260);
    listFM(:, 2) = 1e7;
    
    for i = 1:numel(fname)
        frame = imread(fname{i});
        
        %frame = log10(double(maxImg)./double(frame));
%         filteredFrame = conv2(double(frame), fspecial('log', 12, 16), 'same');
%         filteredFrame(filteredFrame < 0.5) = 0;
        [listROI, circ] = findRBC(frame, area, id, maxImg);
        fm = zeros(size(listROI, 1), 1);
    
        for j = 1:size(fm, 1)        

            fm(j) = fmeasure(frame, fmStr, listROI(j, :));
            
            % Normalize by background intensity
            fm(j) = fm(j)/mean2(imcrop(maxImg, listROI(j, :)));

        end

        % Normalize by RBC circumference
        fm = fm./circ;
        
        % In the case that there are NO RBCs found in the path
        if ~isempty(fm)
            for j = 1:numel(fm)

                listFM(listROI(j, 2), i) = fm(j);
            end
        end
    end
 
    listFM(listFM == 0) = NaN;
    listFM(listFM == 1e7) = NaN;

end