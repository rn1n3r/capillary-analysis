% Function to get path containing frames
% fname = get_fnames()
% fname = get_fnames(path)
% fname = get_fnames(path, ext)
function [fnames, path] = get_fnames (varargin)

path = [];
ext = 'png'; % Default is png files

if nargin >= 1
    path = varargin{1};
    if nargin == 2
        ext = varargin{2};
    end
end

% Find the path
if isempty(path)
    path = uigetdir;
end

% Cancelling out of the dir selection will break out of the function
if path == 0
    error('Cancelled path selection');
end


% Build the path string
if ~(path(end) == '/')
    path = strcat(path, '/');
end

tempNames = dir(strcat(path, '*.', ext));

% Loop until the path is valid (reopen uigetdir)
while isempty(tempNames)
    fprintf('Error: no files found with a valid extension\n');
    path = uigetdir('/Volumes/DATA-2/Captured/');
    if path == 0
        error('Cancelled path selection')
    end
    path = strcat(path, '/');
    tempNames = dir(strcat(path, '*.', ext));
end

fnames = cell(size(tempNames));

for i = 1:size(tempNames, 1)
    fnames{i} = strcat(path, tempNames(i).name);
end


end