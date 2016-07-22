% Class to represent point charge potential
% Physics might be wrong, oh well
% Claire owes me food

classdef potentialPoint
    properties
        r % Radius
        x % x-values
        y % y-values
        z % z-values
        x_origin
        y_origin
        z_origin
        q
        d % distance from origin
        V % voltage values
        Ex % Electric field
        Ey % Electric field
        Ez % Electric field
        E % magnitude
    end
    
    methods
        function obj = potentialPoint (x, y, z, x_origin, y_origin, z_origin, q)
        % Constructor

            obj.x_origin = x_origin;
            obj.y_origin = y_origin;
            obj.z_origin = z_origin;
            
            k = 8.987551e9;
            obj.q = q;
                                    
            % Meshgrid that
            [obj.x, obj.y, obj.z] = meshgrid(x,y,z);
         
            
            % Calculate distance and voltage
            obj.d = sqrt((x_origin - obj.x).^2 + (y_origin - obj.y).^2 + (z_origin - obj.z).^2);
            obj.V = k * obj.q / obj.d;
            
            % Calculate electric field
            [obj.Ex, obj.Ey, obj.Ez] = gradient(obj.V);
            obj.Ex = -obj.Ex;
            obj.Ey = -obj.Ey;
            obj.Ez = -obj.Ez;
            
            
        end
        
        function plotPoint(obj)
            % Contour plot of voltages
            contour3(obj.x(:), obj.y(:), obj.z(:), [], obj.V(:));
            
            hold on;
            %Re=all(isfinite(obj.Ex)&isfinite(obj.Ey)&isfinite(obj.Ez)); 
            %quiver3(obj.x(:), obj.y(:), obj.z(:),obj.Ex(:), obj.Ey(:), obj.Ez(:));
            streamslice(obj.x, obj.y, obj.z, obj.Ex, obj.Ey, obj.Ez, obj.x, 0, 0);
            hold off;
        end
            
    end
    
end