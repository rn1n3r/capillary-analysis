% ****** Velocity Calculator, storing the velocity with the right side
% frame

function velocities = velocityCalculator(finaltracks)
numTracks = size(finaltracks,1);
velocities = cell(numTracks,1);
birth = 10;
death = 161;

for i = 1:size(finaltracks,1)
    
    id = finaltracks{i};
    
    % throw out top and bottom 3 points due to incomplete RBCS - not true
    % centroids
    id(id(:,3) <= birth , :) = [];
    id(id(:,3) >= death , :) = [];

%     id(1:3,:) = [];
%     id(end-2:end,:) = [];
   
    % constants
    avgFPS = 20.67;
    magPxConstant = 0.66189;
    secPerFrame = 1/avgFPS; 
        
    for j = 1:size(id,1)-1

        cur = id(j,:);
        next = id(j+1,:);
       
       % units = microns per second
       vel = ((sqrt((next(2) - cur(2))^2 + (next(3) - cur(3))^2)) * magPxConstant) / ((next(1) - cur(1)) *  secPerFrame);
       
       % throw out first point because can't calculate velocity
       velocities{i}(end+1,:) = [next(1) vel];
               
    end
    
    
end


% assignin('base', 'velocities', velocities);
% save('050417velocities.mat', 'velocities');

%toss out bad velocities
tossedOut = [];
for i = 1:size(velocities,1)
   
    id = velocities{i};
    
    if ~isempty(id) && any(id(:,2) > 300)
       
        tossedOut = [tossedOut i];
        velocities{i} = [];  
    end
        
end

%compute a ratio of tossed / kept
size(tossedOut,2) / size(velocities,1) % fraction tossed tracks vs good tracks


end
