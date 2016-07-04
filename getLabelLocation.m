% Used in frame_gui to find a location to place the ID label of a capillary
% Puts it at the highest y-coordinate

function coords = getLabelLocation(area, idList)

coords = zeros(size(idList));

for i = 1:size(idList, 1)
% Get smallest Y-value
indices = find(area == idList(i, 1));

subs = zeros(numel(indices), 2);
[subs(:, 1), subs(:, 2)] = ind2sub(size(area), indices);
subs = sortrows(subs, 1);
coords(i, :) = subs(1, :);

end
end