% Script to highlight the area with the highest variance in frame

if ~exist('frames', 'var')
    fprintf('Loading frames...\n');
    frames = load_frames;
end

[areas, idList] = getCapillaries(var_img, frames);

firstFrame = squeeze(frames(1,:,:));

variances = zeros(1, length(idList));

for i=1:length(idList)

    pixels = firstFrame(areas == idList(i));
    variances(i) = var(pixels)./(mean(pixels) * numel(pixels));


end

for i = 1:2
    figure
    
    highlightVar = firstFrame;
    [~, maxId] = max(variances);
    highlightVar(areas ~= idList(maxId)) = 0;
    imshow(highlightVar, []);
    
    variances(maxId) = 0;

end

