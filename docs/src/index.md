# QuantumAnnealingAnalytics Documentation

```@meta
CurrentModule = QuantumAnnealingAnalytics
```

## Overview

QuantumAnnealingAnalytics is a Julia package for plotting outputs from the QuantumAnnealing package.
For more information on Quantum Annealing, see the documentation page for QuantumAnnealing.jl, found
[here](https://lanl-ansi.github.io/QuantumAnnealing.jl/stable/).  This Package is effectively a wrapper
around Plots.jl, and can handle the kwargs passed to Plots.jl in addition to those explicitely listed.

## Installation

The latest stable release of QuantumAnnealing can be installed using the Julia package manager with

```julia
] add QuantumAnnealingAnalytics
```

For the current development version, "checkout" this package with

```julia
] add QuantumAnnealingAnalytics#master
```

Test that the package works by running

```julia
] test QuantumAnnealingAnalytics
```

## Quick Start

Load the package and build a two spin ferromagnetic Ising model for simulation,
```julia
using QuantumAnnealing, QuantumAnnealingAnalytics

ising_model = Dict((1,) => 0.1, (1,2) => -1.0)
```

Plot an annealing schedule
```julia
plt = plot_annealing_schedule(AS_CIRCULAR)
```

Perform a basic simulation with an annealing time of `2.0` and the linear annealing schedule, and plot the probability distribution
```julia
ρ = simulate(ising_model, 2.0, AS_LINEAR)
plt = plot_states(ρ)
```

Increase the annealing time to approach the adiabatic limit,
```julia
ρ = simulate(ising_model, 5.0, AS_LINEAR)
plt = plot_states(ρ)
```

Change the annealing schedule and observe different state probabilities and save the results to a file,
```julia
ρ = simulate(ising_model, 5.0, AS_QUADRATIC)
plt = plot_states(ρ)
savefig(plt, "file.pdf")
```

Store intermediate steps in the anneal and plot instantaneous state measurement probabilities
```julia
ρ_steps=[]
ρ = simulate(ising_model, 5.0, AS_LINEAR, state_steps=ρ_steps)
plt = plot_state_steps(ρ_steps)
```

create an ising model and plot how the states at the end of the anneal vary with annealing time
```julia
ising_model = Dict((1,) => 1, (2,) => -0.5, (1,2) => -0.9)
plt = plot_varied_time_simulations(ising_model, AS_LINEAR, (0.001, 100))
```

create a Hamiltonian as a function of `s` and plot the instananeous energy levels
```julia
ising_model = Dict((1,) => 1, (2,) => -.5, (1,2) => -0.9)
H(s) = transverse_ising_hamiltonian(ising_model, AS_LINEAR, s)
plt = plot_hamiltonian_energy_spectrum(H)
```
