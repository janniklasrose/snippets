# Estimating the number of spins

The net number of spins in an MR imaging voxel can be estimated using the Boltzmann distribution
```math
\frac{N^+}{N^-} = \exp(-\frac{\Delta E}{k T})
```
and the Zeeman effect
```math
\Delta E = \gamma \hbar B_0 \, .
```

The result of the calculation in `number_of_spins.py` (below) is of order O(10<sup>11</sup>):
```console
jan@localhost:~/scripts $ python3 number_of_spins.py
The Boltzmann factor is 9.999802e-01 at room temperature and B0 = 3T
For 1e+16 spins, this results in a net difference of 9.882621e+10
```
