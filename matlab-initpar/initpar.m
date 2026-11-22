function [] = initpar(NumWorkers, NumThreads, LocalUseMpiexec, JobStorageLocation)
    %INITPAR Initialises custom parallel pool
    %   When using MATLAB on HPC systems, the following problems can arise with the
    %     parallel computing toolbox (e.g. `parfor`):
    %     - The cluster profile is not set up for the number of cores available
    %     - Too many concurrent instances of MATLAB with their own parallel pools
    %       cause conflicts with each other due to simultaneous writes to the
    %       '~/.matlab/local_cluster_jobs/VERSION/' job storage directory
    %
    %   This function allows the user to overwrite default cluster profile and
    %     initialise a parpool with the requested number of cores.
    %
    %   Arguments:
    %     - NumWorkers          (int) number of parallel workers in the pool
    %     - NumThreads          (int) number of processor threads per worker
    %     - JobStorageLocation  folder path (absolute, or relative on Unix) to store cluster data
    %     - LocalUseMpiexec     (bool) use local MPI [MathWorks support recommendation if error]
    %
    %   See also parpool

    %TODO:
    %   - Process arguments as Name,Value pairs

    %   Copyright (c) 2020 Jan N Rose

    % check that the license exists, terminate if it does not
    if ~license('test', 'Distrib_Computing_Toolbox')
        warning('initpar:noLicense', 'Found no license for the Distributed Computing Toolbox!');
        return
    end

    % process arguments

    if nargin < 1 % NUMWORKERS
        % use as many workers as *physical* cores
        set_NumWorkers = false;
        NumWorkers = feature('numcores'); % undocumented built-in function
    else
        set_NumWorkers = true;
        validateattributes(NumWorkers, {'numeric'}, {'scalar', 'integer', 'positive', 'finite'});
    end
    
    if nargin < 2 % NUMTHREADS
        NumThreads = 1; % 2 for hyperthreading
    else
        validateattributes(NumThreads, {'numeric'}, {'scalar', 'integer', 'positive', 'finite'});
    end

    if nargin < 3 % LOCALUSEMPIEXEC
        distcomp.feature('LocalUseMpiexec', LocalUseMpiexec);
    else
        validateattributes(LocalUseMpiexec, {'numeric', 'logical'}, {'scalar', 'binary'});
    end
    
    if nargin < 4 % JOBSTORAGELOCATION
        set_JobStorageLocation = false;
    else
        set_JobStorageLocation = true;
        validateattributes(JobStorageLocation, {'char', 'string'}, {'scalartext'});
        % has to be absolute path
        if isunix() && ~strcmp(JobStorageLocation(1), '/')
            % relative path, so let's make it absolute
            JobStorageLocation = fullfile(pwd(), JobStorageLocation);
        end
    end

    % check for existing pool
    pool = gcp('nocreate'); % returns pool or []
    if ~isempty(pool)
        if set_NumWorkers && NumWorkers ~= pool.NumWorkers % if we requested CPUs, confirm size
            warning('initpar:wrongSize', ...
                'A parallel pool already exists with %d cores, but %d were requested!', ...
                pool.NumWorkers, NumWorkers);
        end
        return % no need to create a new one
    end

    % modify the default profile
    cluster = parcluster(parallel.defaultClusterProfile); % usually 'local'
    cluster.NumWorkers = NumWorkers;
    cluster.NumThreads = NumThreads;

    % change cluster storage location
    if set_JobStorageLocation
        [~, hostname] = system('hostname');
        hostname = strtrim(hostname); % remove line ending
        JobStorageLocation = fullfile(JobStorageLocation, hostname); % add hostname
        [direxists, msg] = mkdir(JobStorageLocation); % create directory (unless it exists)
        assert(direxists, 'initpar:mkdir', ...
            'Failed to create directory "%s" with error message: "%s"', ...
            JobStorageLocation, msg);
        cluster.JobStorageLocation = JobStorageLocation; % assign for storage
    end

    % start
    timeout = inf; % never
    parpool(cluster, NumWorkers, 'IdleTimeout', timeout);

end
