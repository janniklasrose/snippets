if ispc() % Windows
    cmd = 'dir /a'
elseif ismac() % macOS
    cmd = 'ls -a'
elseif isunix() % Linux (or macOS, which was already caught)
    cmd = 'ls -a --color=auto'
    % MATLAB won't show colour, but the option doesn't work in macOS
else
    error('Unknown OS encountered!');
end
system(cmd); % we can't use ! to escape if we want dynamic arguments
