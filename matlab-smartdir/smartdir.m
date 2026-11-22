function [files, folders] = smartdir(varargin)
%SMARTDIR List files and folders in current directory
%   Calls the MATLAB command `dir` and filters the output into files & folders
%
%   See also dir

%   Copyright (c) 2019 Jan N Rose

list = dir(varargin{:}); % creates array of structs for each file/folder
dir_flags = [list.isdir]; % links to directories are treated as directories
files = list(~dir_flags);
folders = list(dir_flags);
folders(ismember({folders.name}, {'.', '..'})) = [];  %remove . and ..

end
