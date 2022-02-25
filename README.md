# QuantumAnnealingAnalytics.jl
[![CI](https://github.com/lanl-ansi/QuantumAnnealingAnalytics.jl/workflows/CI/badge.svg)](https://github.com/lanl-ansi/QuantumAnnealingAnalytics.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/lanl-ansi/QuantumAnnealingAnalytics.jl/branch/main/graph/badge.svg?token=0MYSS2hWWH)](https://codecov.io/gh/lanl-ansi/QuantumAnnealingAnalytics.jl)
[![Documentation](https://github.com/lanl-ansi/QuantumAnnealingAnalytics.jl/workflows/Documentation/badge.svg)](https://lanl-ansi.github.io/QuantumAnnealingAnalytics.jl/dev/)

Tools for Visualization of Quantum Annealing

## Dependencies
This package assumes that you have installed [QuantumAnnealing.jl](https://github.com/lanl-ansi/QuantumAnnealing.jl)

## Quick Start

Install the packages,
```
] add QuantumAnnealing, QuantumAnnealingAnalytics
```

Load the package and build a two spin ferromagnetic Ising model for simulation,
```
using QuantumAnnealing, QuantumAnnealingAnalytics

ising_model = Dict((1,) => 0.1, (1,2) => -1.0)
```

Plot an annealing schedule
```
plt = plot_annealing_schedule(AS_LINEAR)
```

Perform a basic simulation with an annealing time of `2.0` and the linear annealing schedule, and plot the probability distribution
```
ρ = simulate(ising_model, 2.0, AS_LINEAR)
plt = plot_states(ρ)
```

Increase the annealing time to approach the adiabatic limit,
```
ρ = simulate(ising_model, 5.0, AS_LINEAR)
plt = plot_states(ρ)
```

Change the annealing schedule and observe different state probabilities and save the results to a file,
```
ρ = simulate(ising_model, 5.0, AS_QUADRATIC)
plt = plot_states(ρ)
savefig(plt, "file.pdf")
```

Store intermediate steps in the anneal and plot instantaneous state measurement probabilities
```
ρ_steps=[]
ρ = simulate(ising_model, 5.0, AS_LINEAR, state_steps=ρ_steps)
plt = plot_state_steps(ρ_steps)
```

# License
This software is provided under a BSD-ish license with a "modifications must be indicated" clause.  See the `LICENSE.md` file for the full text. This package is part of the Hybrid Quantum-Classical Computing suite, known internally as LA-CC-16-032.

