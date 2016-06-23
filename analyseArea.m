function totalEdgeCount = analyseArea(areas, idList, fnames, name)
    
    % Get the total number of pixels in edges found in each region
    totalEdgeCount = zeros(size(idList));
    totalEdgeCount(:, 1) = idList(:, 1);
    totalEdgeCount(:, 3:7) = 0;
    
    h = waitbar(0, 'Analysing fnames...please wait');
    for i = 1:100:1260
         currentFrame = imread(fnames{i});
        
        % Find the edges in the current frame for only the areas of
        % interest
        windowEdge = edge(currentFrame, 'canny', 0.5);
        windowEdge(~areas) = 0;

        % For EOL, applies the Laplacian convultion
        EOL = imfilter(currentFrame, fspecial('laplacian'), 'replicate', 'conv').^2;
        
        % Gaussian derivative
        gder = fmeasure(currentFrame, 'GDER');
        
        % HELM
        helm = fmeasure(currentFrame, 'HELM');
        
        % GLLV
        gllv = stdfilt(currentFrame, ones(15, 15)).^2;
        gllv = stdfilt(gllv, ones(15, 15)).^2;
        
        % Range filter
        rangeFilt = rangefilt(currentFrame);
        
        % Go through each R.OI and get the focus measure
        for j = 1:size(idList, 1)
            % Add up all edgels
            totalEdgeCount(j, 2) = totalEdgeCount(j, 2) + sum(windowEdge(areas == idList(j, 1)))./sum(sum(areas == idList(j, 1)));
            
            % EOL
            sumEOL = EOL(areas == totalEdgeCount(j, 1));
            sumEOL = mean2(sumEOL); 
            totalEdgeCount(j, 3) = totalEdgeCount(j, 3) + sumEOL;
            
            % Rangefilt
            rangeMean = mean2(rangeFilt(areas == totalEdgeCount(j, 1)));
            totalEdgeCount(j, 4) = rangeMean;
            
            % GDER
            totalEdgeCount(j, 5) = mean2(gder(areas == totalEdgeCount(j, 1)));
            
            % GLLV
            totalEdgeCount(j, 6) = mean2(gllv(areas == totalEdgeCount(j, 1)));
            
            % HELM
            totalEdgeCount(j, 7) = mean2(helm(areas == totalEdgeCount(j, 1)));
            
        end
        
        if ~mod(i - 1, 60)
            waitbar(i/1260);
        end
        
    end
    close(h);
    
    totalEdgeCount(:, 2) = totalEdgeCount(:, 2);
    totalEdgeCount(:, 3) = totalEdgeCount(:, 3);
    totalEdgeCount = flipud(sortrows(totalEdgeCount, 2));
    % Throw out the regions that found no edges
    for i = 1: size(totalEdgeCount, 1)
        if ~totalEdgeCount(i, 2)
            areas(areas == totalEdgeCount(i, 1)) = 0;
        end
    end
    
    names = size(totalEdgeCount(:, 1));
    % Rename edges
    for i = 1:size(totalEdgeCount(:, 1))
        names(i) = name*100 + i;
    end
    totalEdgeCount = [names' totalEdgeCount];
   

end