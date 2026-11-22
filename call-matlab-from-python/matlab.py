# (re-)connect to MATLAB
import matlab.engine
engine = matlab.engine.start_matlab()

# call built-in or custom .m function directly
a = engine.linspace(0.0, 1.0, 501)
a = a[0]  # engine returns a like this: [[0, ..., 1]]

# evaluate expressions
def run(command):
    engine.eval(command, nargout=0)
run("A = magic(3);")
run("b = rand(3, 1);")
run("x = A\\b;")  # need to escape backslash operator
x = engine.workspace["x"]

# add custom user path
if '__file__' not in locals():  # e.g. for iPython
    __file__ = '.'
import os
codedir = os.path.join(os.path.dirname(__file__), 'rel/path/to/dir')
engine.addpath(codedir, nargout=0)
