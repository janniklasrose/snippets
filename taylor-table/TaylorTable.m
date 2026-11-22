function [weights] = TaylorTable(order, stencil)
%TAYLORTABLE Finite difference approximation via Taylor series expansion
%   Performs a Taylor table analysis to find coefficients that approximate a
%    derivative of given order using the provided finite difference stencil.
%
%    Inputs:
%       order    -  order of derivative to be approximated
%       stencil  -  stencil
%   Outputs:
%       weights  -  coefficients of the Taylor table, such that:
%                   $$\frac{d^k U(0)}{dx^k} = \sum_j{ w(j)U(x(j)) }$$
%
%   Example:
%       weights = TaylorTable(3, [-1, 0, +1])
%       >> weights =
%       >>      1    -2     1
%
%   See also https://mathworks.com/matlabcentral/fileexchange/29897

%   Copyright (c) 2019 Jan N Rose

% checks
narginchk(2,2);
validateattributes(order, {'numeric'}, ...
    {'scalar', 'real', 'finite', 'integer', 'nonnegative'});
validateattributes(stencil, {'numeric'}, ...
    {'vector', 'real', 'finite'});
nPoints = length(stencil); % aux variable
assert(nPoints > order, 'TaylorTable:stencilSize', ...
    'Stencil too small, %d points required for order %d', nPoints+1, order);
assert(numel(unique(stencil)) == numel(stencil), 'TaylorTable:badStencil', ...
    'Non-unique stencil, this will not work');

% matrix: Taylor table CORE (factorial terms)
jj = 0:nPoints-1;
A = transpose(stencil(:).^jj ./ factorial(jj)); % [N x N]

% right hand side: Taylor table RHS (Operator terms)
b = zeros(nPoints, 1);
b(order+1) = 1;

% solve the system
weights = A\b;
weights = reshape(weights, size(stencil)); % match input

end
