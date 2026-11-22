function restart(agree)
% RESTART Used to "reset" most of MATLAB to avoid a restart
%   RESTART() will close files and windows, delete variables, etc.
%
%   RESTART(true) can be used to skip the confirmation dialog
%
%   See also clear

%   Copyright (c) 2020 Jan N Rose

% set default and validate arguments
narginchk(0, 1); % zero or one argument
if ~nargin % no argument
    agree = true;
end
validateattributes(agree, {'logical'}, {'scalar'}, 'restart', 'agree', 1);

% confirm dialog
if ~allowed_to_proceed(agree)
    return % aborted
end

% execute core function
perform_reset;

% clear command window
clc;

% run startup script
evalin('base', 'startup'); % startup() would put variables in fn workspace

end

function [proceed] = allowed_to_proceed(agree)

stack = dbstack;
%stack(1).name is this function @allowed_to_proceed
%stack(2).name is the called function @restart
%stack(3:end) is the caller stack (should be nothing, if called from Command Window)
if length(stack) > 2
    proceed = false;
    warning('@restart can only be called from the Command Window!');
    return
end

if agree % just print a warning
    fprintf('\n!!! Restarting MATLAB now !!!\n');
    fprintf('[5 second wait, hit CTRL+C to abort]');
    pause(5);
    fprintf('\n');
    proceed = true;
else % ask for confirmation
    if ~isempty(java.lang.System.getProperty('java.awt.headless'))
        % running headless (see https://gitlab.com/snippets/1878689 for test)
        answer = input('Please confirm with Y/[N]: ', 's');
        yes = {'y', 'yes'}; % anything else will evaluate to false
        proceed = any(cellfun(@(y) strcmpi(answer, y), yes)); % ignore case
    else
        quest = ['Do you really want to clear MATLAB?', ' ', ...
            'Consult `>> help restart` to see what will happen!'];
        answer = questdlg(quest, 'restart', 'Yes', 'No', 'No');
        proceed = strcmp(answer, 'Yes'); % closing dialog window => false
    end
end

end

function perform_reset

% close all open files
fclose('all');

% close all figures
close('all', 'hidden');

% remove breakpoints
dbclear('all');

% stop and delete profiler
profile('off');
profile('clear');

% suspend diary
diary('off');

% reset random number generator
rng('default');

% clear all variables, functions, etc.
evalin('base', 'clear all'); % clear('all') would clear fn workspace

%%% Toolboxes

% close imtool windows
if license('test', 'Image_Toolbox') % Image Processing Toolbox
    imtool('close', 'all');
end

% reset gpus (if any)
if license('test' , 'Distrib_Computing_Toolbox') % Parallel Computing Toolbox
    for gpuID = 1:gpuDeviceCount()
        reset(gpuDevice(gpuID));
    end
    delete(gcp('nocreate'));
end

end
