# Initialise MATLAB parallel pool on HPC systems

When using MATLAB on HPC systems, the following problems can arise with the parallel computing toolbox (e.g. `parfor`):

- The cluster profile is not set up for the number of cores available
- Too many concurrent instances of MATLAB with their own parallel pools cause conflicts with each other due to simultaneous writes to the `~/.matlab/local_cluster_jobs/VERSION/` job storage directory

This function allows the user to overwrite default cluster profile and initialise a parpool with the requested number of cores.
