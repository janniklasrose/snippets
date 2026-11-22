function save_workspace(filename, maxSize, varargin)
%SAVE_WORKSPACE Script to save all variables
%
%   Inputs:
%       FILENAME  : e.g. fullfile(userpath, 'workspace.mat')
%       MAXSIZE   : maximum size in Bytes (may be empty for default [1GB], inf for no limit)
%       VARIABLES : output of `whos()` or list of variables
%
%   Usage:
%       SAVE_WORKSPACE(FILENAME) saves all variables in the caller workspace with size <= 1GB
%       SAVE_WORKSPACE(FILENAME, MAXSIZE) saves all variables in the caller workspace with size
%           smaller than MAXSIZE
%       SAVE_WORKSPACE(FILENAME, MAXSIZE, VARIABLES) saves the specified variables. VARIABLES can be
%           either names ("variable" or 'variable') or output of @whos (e.g. `whos('variable')`).
%       SAVE_WORKSPACE(FILENAME, [], VARIABLES) does the same, but allows the user to skip the
%           MAXSIZE argument.

%   Copyright (c) 2020 Jan N Rose

%%% input check
narginchk(1, inf); % at least the first one
validateattributes(filename, {'char', 'string'}, {'scalartext'});
if nargin < 2 || isempty(maxSize)
    maxSize = 1e9; % 1GB as default max .mat file size
end
validateattributes(maxSize, {'numeric'}, {'scalar', 'nonnegative'});

%%% parse arguments
if isempty(varargin) % variables not specified
    caller_whos = evalin('caller', 'whos()'); % get caller workspace
    varargin{1} = caller_whos;
end
is_scalartext = cellfun(@isScalarText, varargin);
is_whosstruct = cellfun(@isWhosStruct, varargin);
if ~all(is_whosstruct | is_scalartext)
    error('Invalid argument, needs to be variable name or output of whos()');
end

% call whos() for all variables specified by name
if any(is_scalartext)
    varnames_cell = varargin(is_scalartext);
    varnames = cells2commastr(varnames_cell);
    cmd = sprintf('whos(%s)', varnames);
    res = evalin('caller', cmd); % ignores non-existent variables
    whos_cell1 = {res};
else
    whos_cell1 = {};
end

if any(is_whosstruct)
    whos_cell2 = reshape(varargin(is_whosstruct), [], 1); % column
end

whos_ = cell2mat(vertcat(whos_cell1, whos_cell2));
names = {whos_.name};
[~,idx,~] = unique(names);
vars_all = whos_(idx);

%%% remove invalid objects
valid = true(1, numel(vars_all));
regexp_objGUI = '^matlab\.(ui|graphics)\.'; % UI and graphics objects
regexp_objPar = '^parallel\.cluster\.Local'; % parallel cluster
for exp = {regexp_objGUI, regexp_objPar}
    valid = valid & cellfun(@isempty, regexp({vars_all.class}, exp));
end
for var = vars_all(~valid).'
    fprintf('Ignoring variable "%s" of class "%s"\n', var.name, var.class);
end
vars = vars_all(valid);

%%% save
if isempty(vars) % empty workspace
    vars_tosave = {''}; % save nothing but still execute save() to create empty file
else % go ahead and save
    bytes = [vars.bytes];
    [bytes, idx] = sort(bytes); % sort
    vars = vars(idx); % rearrange
    fits = cumsum(bytes) <= maxSize; % limit
    if any(~fits) % some don't fit
        fprintf('\nCannot save entire workspace (%f B)\n', sum(bytes));
        for i = find(~fits)
            fprintf('\tSkipping variable "%s", it is too big (%f B)\n', ...
                vars(i).name, vars(i).bytes);
        end
    end % now it will fit
    vars_tosave = {vars(fits).name};
end
vars_save_char = cells2commastr(vars_tosave);
cmd = sprintf('save(''%s'', %s, ''-v7.3'')', filename, vars_save_char);

try
    evalin('caller', cmd);
catch me
    rethrow(me);
end

end

function [bool] = isScalarText(s)

bool = isStringScalar(s) || ( ischar(s) && isrow(s) );

end

function [bool] = isWhosStruct(s)

dummy = whos('s');

bool = isstruct(s) && isequal(fieldnames(s), fieldnames(dummy));

end

function [commastr] = cells2commastr(cells)

commastr = sprintf('''%s'', ', cells{:});
commastr = commastr(1:end-2); % strip last space and comma

end
