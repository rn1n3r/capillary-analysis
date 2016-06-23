% Function that loads frames from a directory
% Usage: frames = load_frames(nFrames, height, width, extension, path)
% Leaving any of these blank will set the values to the defaults

function [frames, path] = load_frames (varargin)

clear frames;

% nFrames, height, width, extension
params = {1260, 520, 696, 'png'};

% Assign variables that have inputs
if nargin ~= 0
    for i = 1:4
        if ~isempty(varargin{i}) 
            params{i} = varargin{i};
        end      
    end
end

% If the path is specified, just use it. Otherwise, open uigetdir to find
% the path
if nargin == 5
    path = varargin{5};
else
    % Find the path
    path = uigetdir;

    % Cancelling out of the dir selection will break out of the function
    if path == 0
        error('Cancelled path selection')
    end
end

% Build the path string
if ~(path(end) == '/')
    path = strcat(path, '/');
end

fnames = dir(strcat(path, '*.', params{4}));

% Loop until the path is valid (reopen uigetdir)
while isempty(fnames)
    fprintf('Error: no files found with a valid extension\n');
    path = uigetdir('/Volumes/DATA-2/Captured/');
    if path == 0
        error('Cancelled path selection')
    end
    path = strcat(path, '/');
    fnames = dir(strcat(path, '*.', params{4}));
end

% Initialize the frames matrix
numfids = length(fnames);
frames = zeros(params{1}, params{2}, params{3});
tic

h = waitbar(0, 'Loading frames...please wait');

% Loop through each file and read into frames
for K = 1:numfids
  frames(K, :, :) = imread(strcat(path, fnames(K).name));
  
  if ~mod(K, 100)
    waitbar(K/numfids);
  end
  
end
close(h);

toc

end