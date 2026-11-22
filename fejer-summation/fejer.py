import math
import numpy as np
import matplotlib.pyplot as plt

# define problem
N = 2000
L = 2
x = np.linspace(-0.1*L, 1.1*L, N)  # domain
xmodL = x%L
y0 = +1*(xmodL<1) + -1*(xmodL>1)  # square wave

# fourier series
odd = np.arange(1, 100, 2)  # odd terms up to 100
odd = np.reshape(odd, (-1, 1))  # prepare for broadcast multiply
fs = 4/math.pi * np.sin(odd * 2*math.pi * x/L) / odd

# summation
y1 = np.sum(fs, 0)  # simply sum the terms
ps = np.cumsum(fs, 0) / fs.shape[0]  # running average = partial sum
y2 = np.sum(ps, 0)

# show
fig = plt.figure()
plt.plot(x, y0, label='y(x)')
plt.plot(x, y1, label='S(x) Fourier')
plt.plot(x, y2, label='S(x) Fejer')
plt.xlabel('x')
plt.ylabel('y')
plt.legend(loc='best')
plt.show()
