function [isheadless] = isHeadless()
%ISHEADLESS Determine if graphics are disabled
%   ISHEADLESS returns 1 (true) if Java property java.awt.headless is set
%
%   See also java, http://mathworks.com/matlabcentral/answers/26110

%   Copyright (c) 2019 Jan N Rose

headless = java.lang.System.getProperty('java.awt.headless');
isheadless = ~isempty(headless);

end
