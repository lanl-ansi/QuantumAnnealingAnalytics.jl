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
