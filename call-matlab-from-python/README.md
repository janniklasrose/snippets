# Calling MATLAB from Python

This is just a small summary. For more details, consult the [MathWorks support page](https://www.mathworks.com/help/matlab/matlab-engine-for-python.html).

### Installing the MATLAB engine to Python

See also the [official documentation](https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html).

Execute the following:
```bash
python setup.py \
    build --build-base=$(mktemp --directory) \
    install --prefix=$(python-config --prefix)
```

Notes:
* For `conda` users, running `python` in a Python 3.x environment works but `python-config` is usually missing and defaults to the system Python 2.x version. Use `python3-config` instead.
* For the system Python installation, run using `sudo` and make sure `python` and `python-config` refer to the desired versions.
* MATLAB requires a license.
