% ****** Velocity Calculator, storing the velocity with the right side
% frame

numTracks = size(finaltracks,1);
velocities = cell(numTracks,1);
birth = 6;
death = 165;

for i = 1:size(finaltracks,1)
    
    id = finaltracks{i};
    
    % throw out top and bottom points due to incomplete RBCS - not true
    % centroids
    id(id(:,3) <= birth , :) = [];
    id(id(:,3) >= death , :) = [];
   
    % constants
    avgFPS = 20.67;
    magPxConstant = 0.66189;
    secPerFrame = 1/avgFPS; 
        
    for j = 1:size(id,1)-1

        cur = id(j,:);
        next = id(j+1,:);
       
       % units = microns per *second*
       vel = ( (  sqrt(  (next(2) - cur(2))^2 +  (next(3) - cur(3))^2 ) ) * magPxConstant) / ((next(1) - cur(1)) *  secPerFrame);
       
       % throw out first point because can't calculate velocity
       velocities{i}(end+1,:) = [next(1) vel];
               
    end
    
    
end