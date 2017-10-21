% The purpose of this script is to account for missing detections by
% tweaking the parameters of the LoG filter, namely decreasing hsizeh until
% threshold of 14. If no additional detection is found by the LoG by hsizeh
% of 14, then use a euclidean prediction.

function [cur, prev, theMissingOne] = missingFix(i, cur, prev, assn, targetSize)

    
mainDir = '/Users/henry/Desktop/StraightCap2/Captured/20150619/442/X20-FOVp2-4-P/1a';
processedDir = '/Users/henry/Desktop/StraightCap2/Processed/20150619/X20-FOVp2-4-P';

croppedDir = fullfile(mainDir, 'cropped images');
img_list = dir(fullfile(croppedDir, '*.png'));

img_real = imread(fullfile(croppedDir, img_list(i).name));
img_tmp = im2double(img_real);

%newODGen ******

% PSEDUO OD GEN
img_max = imread(fullfile(processedDir, 'X20-FOVp2-4-P-442Max.tif'));
load(fullfile(mainDir, 'cropmtx.mat'));
img_max = im2double(imcrop(img_max, cropMatrix));
img_tmp = log10(img_max ./ img_tmp);

% img_tmp = imcomplement(uint16(img_tmp .* 65536));
img_tmp = 65536 - (img_tmp .* 65536);




%makeLoG *******

hsizeh = 15;
sigmah = 15;
threshold = 0.3;
closeExtrema = 5;
lowerhsizehBound = 10;

k = 0;

origCur = cur;

while (size(cur,1) < targetSize) && hsizeh - k >= lowerhsizehBound

    
    logfilter = fspecial('log', hsizeh - k, sigmah);
    img_blob = imfilter(img_tmp, logfilter, 'replicate');

    % threshold it with the user input param
    img_blob(img_blob < threshold) = 0 ;

        if max(img_blob(:)) > 0
            [xmax,imax,~,~] = extrema2(img_blob);

            %imax contains an array of linear indices. in2sub converts those linear
            %indices to equivalent row and column subscripts 
            [ylist, xlist] = ind2sub(size(img_blob),imax);

            points = horzcat(xlist, ylist, xmax);

            %sort rows based on Y value -- need to specify for direction of
            %movement
            points = sortrows(points, 2);

            % cleanDetections algorithm begins 

            %only for frames with at least one RBC
            if size(points,1) > 1    
                delete = zeros(size(points,1), 1);
                prv = points(1, 1:2);
                for j=2:size(points,1)
                    if eucDistance(prv, points(j,1:2)) <= closeExtrema                        
                            delete(j) = 1;
                    else
                        prv = points(j, 1:2);
                    end
                end

                points((delete == 1), :) = [];
            end


            cur = points(:,1:2);
            k = k + 1;
            
%             if max(img_blob(:)) > 0
%                 img_markers = insertMarker(img_blob, [points(:,1) points(:,2)], 'plus', 'Size', 3, 'Color', 'red');
%             else
%                 img_markers = zeros(size(img_real));
%             end
%             
%             
%             imshow(img_markers);



        else

            %empty frame

        end

end

% Too many missing detections found

while size(cur,1) > targetSize
%     cur(cur(:,2) == 171,:) = [];
    
    highCost = 300;
    % minimize the cost!!!!!!!!!!!
    for j = 1:length(cur)
    
        testCur = cur;
        testCur(j,:) = [];
        [assn, cost] = munkres(pdist2(prev, testCur));
        
        if cost < highCost
           theExtraOne = j;
           highCost = cost;
        end
        
    end
    
    
    cur(theExtraOne, :) = [];
end


% IF missingFix hsizeh tweaking doesn't work, throw out.
% Prediction code 
% if (size(cur,1) < targetSize) && hsizeh - k < 16
%     cur = origCur;
%             
%     velocityConstant = 5;
% 
%     [~, predCur] = delPred(prev, cur, assn, velocityConstant); % predict disappearance(s)
% 
%     cur = predCur;
% 
% end


theMissingOne = 0;

% give up on missing detection and conclude track prematurely
if (size(cur,1) < targetSize) && hsizeh - k < 16
    
    highCost = 300;
    % minimize the cost!!!!!!!!!!!
    for j = 1:length(prev)
    
        testPrev = prev;
        testPrev(j,:) = [];
        [assn, cost] = munkres(pdist2(testPrev, cur));
        
        if cost < highCost
           theMissingOne = j;
           highCost = cost;
        end
        
    end
    
    
    prev(theMissingOne, :) = [];
    
end



return