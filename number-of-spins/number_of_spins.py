from math import exp

gamma = 267.522187e6  # rad/s/T
hbar = 1.054571817e-34  # J.s/rad
k = 1.380649e-23  # J/K

def Boltzmann(dE, T=293.15, Tunit='K'):
    if Tunit == 'C': T += 273.15
    return exp(-dE/k/T)

def Zeeman(B0):
    return gamma * hbar * B0

B0 = 3  # 3T scanner
N_ratio = Boltzmann(Zeeman(B0), 37, 'C')

print(f"The Boltzmann factor is {N_ratio:e} at room temperature and B0 = 3T")

N_total = 1e16  # per mm3 of H2O
N_pos = N_total * N_ratio/(1+N_ratio)
N_neg = N_total - N_pos
N_extra = abs(N_pos - N_neg)

print(f"For {N_total:g} spins, this results in a net difference of {N_extra:e}")
