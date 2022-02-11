# QuantumAnnealingAnalytics.jl
Tools for Visualization of Quantum Annealing

## Dependencies
This package assumes that you have installed [QuantumAnnealing.jl](https://github.com/lanl-ansi/QuantumAnnealing.jl)

## Quick Start

Install the packages,
```
] add QuantumAnnealing
] add QuantumAnnealingAnalytics
```

Load the package and build a two spin ferromagnetic Ising model for simulation,
```
using QuantumAnnealing, QuantumAnnealingAnalytics

ising_model = Dict((1,) => 0.1, (1,2) => -1.0)
```

Perform a basic simulation with an annealing time of `2.0` and the trigonometric annealing schedule, and plot the
probability distribution
```
ρ = simulate(ising_model, 2.0, AS_CIRCULAR)
plt = plot_states(ρ)
```

Increase the annealing time to approach the adiabatic limit,
```
ρ = simulate(ising_model, 10.0, AS_CIRCULAR)
plt = plot_states(ρ)
```

Change the annealing schedule and observe different state probabilities,
```
ρ = simulate(ising_model, 10.0, AS_QUADRATIC)
plt = plot_states(\rho)
```

Store intermediate steps in the anneal and plot instantaneous state measurement probabilities
```
state_steps=[]
ρ = simulate(ising_model, 2.0, AS_CIRCULAR,state_steps=state_steps)
plt = plot_state_steps(state_steps)
```

Plot an annealing schedule
```
plt = plot_annealing_schedule(AS_CIRCULAR)
```

# License
This software is provided under a BSD-ish license with a "modifications must be indicated" clause.  See the `LICENSE.md` file for the full text. This package is part of the Hybrid Quantum-Classical Computing suite, known internally as LA-CC-16-032.

