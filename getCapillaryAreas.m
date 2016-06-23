function areas = getCapillaryAreas (frames)
close all;
%od = log10(squeeze(max(frames))./squeeze(min(frames)));
od = squeeze(max(frames)) - squeeze(min(frames));
edges = edge(od, 'sobel');

area = imdilate(edges,strel('disk',3));
area = imdilate(area,strel('disk',3));
firstFrame = squeeze(frames(1,:,:));
firstFrame(~area) = 0;

imshow(firstFrame, []);


end