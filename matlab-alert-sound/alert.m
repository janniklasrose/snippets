function [] = alert(name)
%ALERT Alerts the user by playing a sound
%   ALERT() plays the 'gong' sound
%
%   ALERT(name) plays one of the following:
%       'chirp', 'gong', 'handel', 'laughter', 'splat', 'train'
%
%   Example:
%       >> sleep(60); alert(); % or some other long-running command
%
%   See also sound

%   Copyright (c) 2019 Jan N Rose

%%% parse argument
stock_sounds = {'chirp', 'gong', 'handel', 'laughter', 'splat', 'train'};
if nargin() == 0
    name = 'gong'; % default
end
validatestring(name, stock_sounds);

%%% play the chosen sound
soundtrack = getfield(load(name), 'y');
sound(soundtrack);

end
