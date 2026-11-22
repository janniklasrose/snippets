%% Calculate

% these functions take query points q with size [Ndim, Nx, Ny, Nz]
g_1D = @(q) squeeze(g_nD(q, [1], [0]));
g_2D = @(q) squeeze(g_nD(q, [1, 1], [0, 0]));
g_3D = @(q) squeeze(g_nD(q, [1, 1, 1], [0, 0, 0]));

% mesh (vary domain length among x-y-z to visualise it better)
x = linspace(-3, +3, 201);
y = linspace(-4, +4,  51);
z = linspace(-5, +5,  51);
dx = x(2) - x(1);
dy = y(2) - y(1);
dz = z(2) - z(1);

% 1D
X_1D = x; % x-vector
q_1D = X_1D;
G_1D = g_1D(q_1D);
assert(isclose(G_1D, normpdf(x)));

% 2D
[X_2D, Y_2D] = meshgrid(x, y);
q_2D = permute(cat(3, X_2D, Y_2D), [3,1,2]);
G_2D = g_2D(q_2D);
assert(isclose(G_2D, g_1D(x).*transpose(g_1D(y))));

% 3D
[X_3D, Y_3D, Z_3D] = meshgrid(x, y, z);
q_3D = permute(cat(4, X_3D, Y_3D, Z_3D), [4,1,2,3]);
G_3D = g_3D(q_3D);
assert(isclose(G_3D, g_1D(x).*transpose(g_1D(y)).*reshape(g_1D(z), 1,1,[])));

% check integrals (should approach 1 as x,y,z go to +/- infinity)
I_1D = sum(G_1D, 'all') * dx;
I_2D = sum(G_2D, 'all') * dx*dy;
I_3D = sum(G_3D, 'all') * dx*dy*dz;

%% Plotting

fig = figure('Color', 'w');
rotate3d(fig, 'on'); % enable rotation tool

ax = subplot(1, 3, 1);
title(ax, '1D g_{nD}');
show_1D(G_1D, X_1D, ax)

ax = subplot(1, 3, 2);
title(ax, '2D g_{nD}');
show_2D(G_2D, X_2D, Y_2D, ax);

ax = subplot(1, 3, 3);
title(ax, '3D g_{nD}');
show_3D(G_3D, X_3D, Y_3D, Z_3D, [0.05, 0.01, 0.001], ax);

%% FUNCTIONS

function [g] = g_nD(X, Sigma, Mu)
    % nD normal (Gaussian) distribution
    % https://en.wikipedia.org/wiki/Multivariate_normal_distribution

    Sigma = Sigma(:); Mu = Mu(:); % columns
    ndim = size(X, 1);
    Det = prod(Sigma); % compute determinant of Sigma, = det(diag(Sigmat))
    numerator = exp(-1/2*sum((X-Mu).^2./Sigma, 1));
    denominator = sqrt((2*pi).^ndim*Det);
    g = numerator/denominator;
end

function [tf] = isclose(a, b, tol)
    if nargin < 3
        tol = eps;
    end
    tf = max(abs(a(:))-abs(b(:))) < tol;
end

function [min_max] = minmax(V)
    min_max = [min(V, [], 'all'), max(V, [], 'all')];
end

function show_1D(C, X, ax)
    if nargin < 3
        ax = gca;
    end
    hold(ax, 'on');
    grid(ax, 'on');
    box(ax, 'on');
    axis(ax, 'tight');
    daspect(ax, [1,0.1,0.1]);
    pbaspect(ax, [1,1,1]);
    xlim(ax, minmax(X));
    xlabel(ax, 'x');

    plot(ax, X, C, 'k-')
end

function show_2D(C, X, Y, ax)
    if nargin < 4
        ax = gca;
    end
    hold(ax, 'on');
    grid(ax, 'on');
    box(ax, 'on');
    axis(ax, 'tight');
    daspect(ax, [1,1,0.03]);
    pbaspect(ax, [1,1,1]);
    xlim(ax, minmax(X));
    ylim(ax, minmax(Y));
    xlabel(ax, 'x');
    ylabel(ax, 'y');
    camlight(ax);
    lighting(ax, 'gouraud');
    view(ax, 3);

    surf(ax, X, Y, C, 'EdgeColor', 'none');
end

function show_3D(C, X, Y, Z, vals, ax)
    if nargin < 6
        ax = gca;
    end
    hold(ax, 'on');
    grid(ax, 'on');
    box(ax, 'on');
    axis(ax, 'tight');
    daspect(ax, [1,1,1]);
    pbaspect(ax, [1,1,1]);
    xlim(ax, minmax(X));
    ylim(ax, minmax(Y));
    zlim(ax, minmax(Z));
    xlabel(ax, 'x');
    ylabel(ax, 'y');
    zlabel(ax, 'z');
    camlight(ax);
    lighting(ax, 'gouraud');
    view(ax, 3);

    for val = vals(:)'
        isosurf = isosurface(X, Y, Z, C, val);
        iso = patch(ax, isosurf, 'FaceColor', 'interp', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
        % update patch
        isonormals(X, Y, Z, C, iso); % use computed iso normals, not original ones
        isocolors( X, Y, Z, C, iso); % color by value (since we use multiple isos)
    end 
end
