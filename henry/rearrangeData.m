function meanVelsPerFrame = rearrangeData(velocities)

    % convert from per track to per frame
    velocities = velocities(~cellfun('isempty',velocities));

    lastFrame = velocities{end}(end,1);
    perFrameVelocities = cell(lastFrame, 1);
    numTracks = size(velocities,1);

    for i = 1:numTracks

        for j = 1:size(velocities{i},1)

            % cell array of each frame, append with track id and velocity
            perFrameVelocities{velocities{i}(j,1)} = [perFrameVelocities{velocities{i}(j,1)}; i velocities{i}(j,2)];

        end

    end

    % calc mean velocities per frame 
    meanVelsPerFrame = zeros(lastFrame,1);

    for i = 1:lastFrame

        if ~isempty(perFrameVelocities{i})
            meanVelsPerFrame(i) = mean(perFrameVelocities{i}(:,2));
        else
            meanVelsPerFrame(i) = NaN;
        end
    end
    
return
