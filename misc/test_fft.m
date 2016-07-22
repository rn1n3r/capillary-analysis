% fs = 1000;                                % Sample frequency (Hz)
% t = 0:1/fs:10-1/fs;                      % 10 sec sample
% x = (1.3)*sin(2*pi*15*t) ...             % 15 Hz component
%   + (1.7)*sin(2*pi*40*(t-2)) ...         % 40 Hz component
%   + 2.5*gallery('normaldata',size(t),4); % Gaussian noise;
% 
% m = length(x);          % Window length
% n = pow2(nextpow2(m));  % Transform length
% y = fft(x,n);           % DFT
% f = (0:n-1)*(fs/n);     % Frequency range
% power = y.*conj(y)/n;   % Power of the DFT

intensity = linspace(0,0,1260);
for i = 1:1260
    pixels = frames(i, :, :);
    intensity(i) = mean(pixels(:));
end


fs = 20;
t = 0:1/fs:10-1/fs;
%y = 3*sin(2*pi*9*t) + cos(2 * pi * 2 * t);
y = max(intensity) - intensity;
n = numel(y);
y = detrend(y);
FFT = fft(y);
power = FFT.*conj(FFT)/n;
f = (0:n-1)*(fs/n);

plot(f(1:n/2), power(1:n/2));

%stem(f(1:n/2), power(1:n/2));