% Gets the fmeasures of all capillaries in the FOV (from fname)
% Make sure to start parallel processing pool!
function fov = getFOVfmeasures(measure, var, fname, maxImg)
    
    % Get the capillary IDs in the FOV
    [~, idList] = getCapillaries(var);

    fov = cell(size(idList, 1), 2);
    fov(:, 1) = num2cell(idList(:, 1));
    [fov{:, 2}] = deal(zeros(520, 1260));
    
    %tic    
%     parfor i = 1:size(idList, 1)
%         temp = getPathFmeasures(fname, var, idList(i, 1), measure, maxImg);
%         fov{i, 2} = temp;
%         fprintf('%d done\n', idList(i, 1));
%     end
%     
    area = getCapillaries(var);
    
    tempMatrix = zeros(520, 1260, size(idList, 1));
  
    parfor i = 1:size(fname, 1)
        listFM = zeros(520, size(idList, 1));
        frame = imread(fname{i});
        edgeFrame = edge(maxImg - frame, 'canny', 0.26);
       
        for j = 1:size(idList, 1)
            [listROI, circ] = findRBC(edgeFrame, area, idList(j, 1));
            fm = zeros(size(listROI, 1), 1);

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
%             listFM(listFM == 0) = NaN;
%             listFM(listFM == 1e7) = NaN;
            tempMatrix(:, i, :) = listFM;
            
        end    

    end
    
    tempMatrix(tempMatrix == 0) = NaN;
    
    for i = 1:size(idList, 1)
        fov{i, 2} = tempMatrix(:, :, i);
    end
    
    
    %toc

end
