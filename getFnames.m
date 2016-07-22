% Function to get path containing frames in FOV
% fname = getFnames()
% fname = getFnames(path)
% fname = getFnames(path, ext)

function [fnames, path] = getFnames (varargin)

    % Default path (works on work computer, change depending on your
    % environment)
    defaultPath = '/Volumes/DATA-2/Captured/';

    % Variables
    path = [];
    ext = 'png'; % Default is png files

    % Set available parameters
    if nargin >= 1
        path = varargin{1};
        if nargin == 2
            ext = varargin{2};
        end
    end

    % Find the path
    if isempty(path)
        path = uigetdir(defaultPath);
    end

    % Cancelling out of the dir selection will break out of the function
    if path == 0
        error('Cancelled path selection');
    end

    % Build the path string
    if ~(path(end) == '/')
        path = strcat(path, '/');
    end

    % Attempt to build list of files
    tempNames = dir(strcat(path, '*.', ext));

    % Loop until the path is valid (reopen uigetdir)
    while isempty(tempNames)
        
        fprintf('Error: no files found with a valid extension\n');
        path = uigetdir(defaultPath);
        if path == 0
            error('Cancelled path selection')
        end

        % Attempt to build list again
        path = strcat(path, '/');
        tempNames = dir(strcat(path, '*.', ext));
    end

    % Convert structure to cell of filenames
    fnames = cell(size(tempNames));

    for i = 1:size(tempNames, 1)
        fnames{i} = strcat(path, tempNames(i).name);
    end


end
