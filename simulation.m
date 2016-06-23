%clean

x = -5:0.75:5;
y = -5:0.75:5;
z = -5:0.75:5;

a = potentialPoint(x, y, z, -2.5, 0, 0, 100);
b = potentialPoint(x, y, z, 2.5, 0, 0, -100);

sum_V = a.V(:) + b.V(:);
[Sx Sy Sz] = meshgrid(sum_V);
contourslice(a.x, a.y, a.z, Sx, Sy, Sz);

sum_Ex = a.Ex + b.Ex;
sum_Ey = a.Ey + b.Ey;
sum_Ez = a.Ez + b.Ez;

hold on;

%quiver3(a.x(:), a.y(:), a.z(:), sum_Ex(:), sum_Ey(:), sum_Ez(:),3);