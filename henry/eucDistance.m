function d = eucDistance(coord1, coord2)

x1 = coord1(1);
y1 = coord1(2);
x2 = coord2(1);
y2 = coord2(2);

d = sqrt((x2-x1)^2+(y2-y1)^2);

return