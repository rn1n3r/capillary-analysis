function [contrasts, corr, energy, homo, meanI, a] = testSliding(var, frames, id)
warning('off', 'all');

area = getCapillaries(var, frames);
firstFrame = getFrame(frames, 1);

%Convert firstFrame into double
firstFrame = firstFrame ./ 2^16;   

windowHeight = 15;

% Get the capillary masked
firstFrame (area ~= id) = NaN;

% Get smallest Y-value
indices = find(area == id);

subs = zeros(numel(indices), 2);
[subs(:, 1), subs(:, 2)] = ind2sub(size(area), indices);

minY = min(subs(:, 1));
maxY = max(subs(:, 1)) - windowHeight;

steps = maxY - minY;


contrasts = linspace(0, 0, steps);
corr = contrasts;
energy = contrasts;
homo = contrasts;
meanI = contrasts;

counter = 1;
maxValues = 1;
a(1:50, 1:2) = NaN;

for j = 1:100:1260
currentY = minY;
for i = 1: steps
    xVals = subs(find(subs(:, 1) <= currentY + windowHeight), 2);
    
    currentFrame = getFrame(frames, j)./ 2^16;
    currentFrame(area ~= id) = NaN;
    rect = currentFrame(currentY:currentY + windowHeight, min(xVals): max(xVals));
%     if (i == 66 || i == 177)
%         figure;
%         imshow(rect, []);
%     end
    glcm = graycomatrix(rect);
    stats = graycoprops(glcm);
    % contrasts(i) = stats.Contrast;
    corr(i) = stats.Correlation;
    % energy(i) = stats.Energy;
    % homo(i)= stats.Homogeneity;
    meanI(i) = nanmean(nanmean(rect));
    currentY = currentY + 1;

end
[~,locs] = findpeaks(max(meanI) - meanI);

% a(1:numel(locs), 2, counter) = corr(locs)';
% a(1:numel(locs), 1, counter) = locs';

b = [locs' corr(locs)'];

a = [a;b];

% if numel(locs) > maxValues
%     maxValues = numel(locs);
% end
counter = counter + 1;

end

% for i = 1:13
%     a(:, :, i) = flipud(sortrows(a(:,:,i), 2));
% end

end