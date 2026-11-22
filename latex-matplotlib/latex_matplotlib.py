import matplotlib
import matplotlib.pyplot as plt

def addpkg(name):
    """Add package to matplotlib latex preamble."""
    preamble = matplotlib.rcParams['text.latex.preamble']
    if name not in preamble:  # to avoid duplicating
        preamble += r'\usepackage{%s}' % name  # add
    matplotlib.rcParams['text.latex.preamble'] = preamble

def make_plot(title, *labels):
    plt.figure()
    ax = plt.gca()
    ax.set_title(title)
    data = (([2,3,4], [0,1,4]), ([1,5,2], [0,0,3]), ([2,1,3], [3,1,2]), ([0,1,2], [5,4,5]))
    for (x, y), lab in zip(data, labels):
        ax.plot(x, y, label=lab)
    ax.set_xlabel('$x$')
    ax.set_ylabel('$F(x_0)$')
    ax.legend()
    plt.tight_layout()

# Without LaTeX
make_plot('Without LaTeX', r'$n/k$', r'$\frac{d^2F}{dx^2}$', r'$\nabla \cdot (D \nabla U)$', r'$p = 5 \mu\Omega$')

# With LaTeX
matplotlib.rcParams['text.usetex'] = True
make_plot('With LaTeX', r'$n/k$', r'$\frac{d^2F}{dx^2}$', r'$\nabla \cdot (D \nabla U)$', r'$p = 5 \mu\Omega$')

# With extra LaTeX packages
addpkg('xfrac')    # for pretty fractions: \sfrac
addpkg('physics')  # for mathematical operations: \dv, \div, \grad
addpkg('siunitx')  # for units: \SI (and units such as \micro, \ohm)
make_plot('With extra LaTeX packages', r'$\sfrac{n}{k}$', r'$\dv[2]{F}{x}$', r'$\div (D \grad U)$', r'$p = \SI{5}{\micro\ohm}$')

# now show all
plt.show()
