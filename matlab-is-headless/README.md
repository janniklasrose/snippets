# Determine if MATLAB is running in headless mode

## Alternative

Versions R2019a and higher support now the [`batchStartupOptionUsed`](https://uk.mathworks.com/help/matlab/ref/batchstartupoptionused.html) command. It can be used to determine if MATLAB was started with the `-batch` option, which is going to be enough for most use cases.
