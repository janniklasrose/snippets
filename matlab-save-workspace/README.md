# Save MATLAB workspace

Put the following **at the very end** of `startup.m` (located in `userpath`):

```MATLAB
% restore workspace from last session
if exist(fullfile(userpath, 'workspace.mat'), 'file') % to avoid error
    load(fullfile(userpath, 'workspace.mat'));
end
```

Put the following **at the very beginning** of `finish.m` (located in `userpath`):

```MATLAB
% save workspace from current session
save_workspace(fullfile(userpath, 'workspace.mat'), 2e9); % save everything
```
