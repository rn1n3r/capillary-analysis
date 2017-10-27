function detections = detect(handles)


detections = cell(size(handles.img_list, 1), 1);

% array = zeros(1,4);
% for x=15:21
% 
%     for y = 15:21
%         
%         for z = 8
            
    % make an LoG filter with the user input parameters
    handles.logfilter = fspecial('log', handles.hsizeh, handles.sigmah);
%     handles.logfilter = fspecial('log', x, y);

    for i=1:size(handles.img_list, 1)

        img_real = imread(fullfile(handles.croppedDir, handles.img_list(i).name));
        img_tmp = im2double(img_real);

        img_tmp = newODGen(handles, img_tmp);
        img_blob = makeLoG(handles, img_tmp);


        % if there is at least one RBC in the frame
        if max(img_blob(:)) > 0
            [xmax,imax,~,~] = extrema2(img_blob);

            %imax contains an array of linear indices. in2sub converts those linear
            %indices to equivalent row and column subscripts 
            [ylist, xlist] = ind2sub(size(img_blob),imax);

            points = horzcat(xlist, ylist, xmax);

            %sort rows based on Y value -- need to specify for direction of
            %movement
            points = sortrows(points, 2);

    %         % delete border cases
    %         
    %         points(points(:,2) > handles.deathzone, :) = [];
    %         points(points(:,2) < handles.birthzone, :) = [];

            % cleanDetections algorithm begins 

            %only for frames with at least one RBC
            if size(points,1) > 1    
                delete = zeros(size(points,1), 1);
                prev = points(1, 1:2);
                for j=2:size(points,1)
                    if eucDistance(prev, points(j,1:2)) <= handles.closeExtrema 
%                     if eucDistance(prev, points(j,1:2)) <= z
                            delete(j) = 1;
                    else
                        prev = points(j, 1:2);
                    end
                end

                points((delete == 1), :) = [];
            end

            detections{i} = points;

        else

            %empty frame

        end

    end

%     your_count = sum(cellfun(@(x) numel(x),detections));
%     array = [array; x y z your_count]
    
    
%         end
%     end
% end
    
mkdir(fullfile(handles.processedDir, 'HENRYMOT'));
save(fullfile(handles.processedDir, 'HENRYMOT', 'detections.mat'), 'detections');



end