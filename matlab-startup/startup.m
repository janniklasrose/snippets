%STARTUP Startup file
%   This file is executed when MATLAB starts up

%   Copyright (c) 2019 Jan N Rose

% cd(userpath()); % with AppsAnywhere on Windows, MATLAB starts in binary dir

%% Toolboxes

% add external toolboxes to path (place in `userpath`/Toolboxes)
% alternatively, put path definitions into `userpath`/pathdef.m
addpath(fullfile(userpath(), 'Toolboxes', 'ezyfit'));
addpath(fullfile(userpath(), 'Toolboxes', 'logicleTransform'));
addpath(fullfile(userpath(), 'Toolboxes', 'RunLength'));

% include the EzyFit menu for all new figures
efmenu(); % see `docezfit`

% start imtool figures with small overview window
if ~isempty(ver('images')) % Image Processing Toolbox
    iptsetpref('ImtoolStartWithOverview', true);
end

%% Errors and Warnings

beep('off');                % disable beep on error
warning('on', 'all');       % enable warnings for all types
warning('on', 'backtrace'); % display backtrace of where the warning occured
warning('off', 'verbose');  % don't display "Type ___ to suppress this warning"
