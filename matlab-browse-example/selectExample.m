function [] = selectExample()
%SELECTEXAMPLE ...

%DISCLAIMER: only tested for versions R2017b and R2019b
%TODO: do we need to warn the user?
%{
switch version('-release')
    case {'2017b', '2019b'}
        % tested
    otherwise
        warning('You are using an untested version of MATLAB');
end
%}

%TODO: uigetfile
%TODO: https://blogs.mathworks.com/pick/2010/02/19/file-and-folder-selection-gui/
%TODO: https://uk.mathworks.com/matlabcentral/fileexchange/10867-uipickfiles-uigetfile-on-steroids

root_examples = fullfile(matlabroot(), 'examples');
LEVEL_ROOT = 0; % at root_examples
LEVEL_INTE = 1; % intermediate
LEVEL_CATE = 2; % category
hasMain = true;
currentDirectory = root_examples;
level = LEVEL_ROOT;
done = false;

while ~done

    % time since last action
    t0 = tic();
    MAX_WAIT = 100;

    % 
    listing = dir(currentDirectory);
    fields = fieldnames(listing);
    listing_cell = struct2cell(listing);
    idx_isdir = find(contains(fields, 'isdir'));
    idx_name = find(contains(fields, 'name'));

    % 
    Name = 'selectExample';
    ListSize = [500, 200];
    switch level
        case LEVEL_ROOT % root

            PromptString = 'Pick a category';
            OKString = 'Open this category';
            CancelString = 'Cancel';
            SelectionMode = 'single';

            ListString = listing_cell(idx_name, 3:end); % ignoring '.' and '..'

            if ~exist('Selection0', 'var'), Selection0 = 1; end
            [Selection0, ok] = listdlg( 'ListString', ListString ...
                                     , 'SelectionMode', SelectionMode ...
                                     , 'ListSize', ListSize ...
                                     , 'InitialValue', Selection0 ...
                                     , 'Name', Name ...
                                     , 'PromptString', PromptString ...
                                     , 'OKString', OKString ...
                                     , 'CancelString', CancelString ...
                                     );

            if ~ok % was aborted
                break;
            else % category was picked
                category = ListString{Selection0};
                currentDirectory = fullfile(currentDirectory, category);
                if hasMain
                    level = LEVEL_INTE;
                    currentDirectory = fullfile(currentDirectory, 'main');
                end
                level = LEVEL_CATE;
            end

            Selection1 = 1;

        case LEVEL_CATE % category

            PromptString = 'Pick an example';
            OKString = 'Open example (or go back with "..")';
            CancelString = 'Cancel';
            SelectionMode = 'single'; % TODO: do we want multiple files to be opened?

            % example files have to end in '*Example.m*'
            ListString = listing_cell(idx_name, 2:end); % ignoring '.'
            idxList = contains(ListString, 'Example.m');
            idxList(1) = true; % also show '..'
            ListString = ListString(idxList);

            if ~exist('Selection1', 'var'), Selection1 = 1; end
            [Selection1, ok] = listdlg( 'ListString', ListString ...
                                     , 'SelectionMode', SelectionMode ...
                                     , 'ListSize', ListSize ...
                                     , 'InitialValue', Selection1 ...
                                     , 'Name', Name ...
                                     , 'PromptString', PromptString ...
                                     , 'OKString', OKString ...
                                     , 'CancelString', CancelString ...
                                     );

            if ~ok % was aborted
                break;
            else % example was picked
                example = ListString{Selection1};
                if strcmp(example, '..') % want back down
                    if ispc()
                        components = strsplit(currentDirectory, '\');
                        back = (LEVEL_CATE-LEVEL_ROOT);
                        currentDirectory = fullfile(components{1:end-back});
                    else % ismac() or isunix()
                        components = strsplit(currentDirectory, '/');
                        currentDirectory = ['/', fullfile(currentDirectory{1:end-1})]; % add root
                    end
                    level = LEVEL_ROOT;
                else % open this example
                    fileComponents = strsplit(example, '.'); % split filename and extension
                    openExample([category, '/', fileComponents{1}]);
                    done = true(); %TODO: do we want to allow more files to be opened?
                end
            end

        otherwise % shouldn't be here
            error('BUG:level', 'Quo vadis?');
    end

    %NOTE: we need `done = true` SOMEWHERE, else MATLAB is doomed (listdlg cannot be aborted)
    if exist('ABORT', 'file') || toc(t0) > MAX_WAIT
        done = true;
    end

end

end
