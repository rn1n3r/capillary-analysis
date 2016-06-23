capillaries = I;
capillaries(capillaries > 60) = 0;
capillaries(capillaries ~= 0) = 1;