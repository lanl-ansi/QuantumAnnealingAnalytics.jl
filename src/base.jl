function spin_hamming_distance(spin_1, spin_2)
    x = _QA.spin2int(spin_1)
    y = _QA.spin2int(spin_2)

    #Kernighan's Algorithm
    diff_bits = xor(x,y)
    hamming_dist = 0
    while diff_bits != 0
        hamming_dist += 1
        diff_bits = diff_bits & (diff_bits-1)
    end
    return hamming_dist
end

function _get_states(ising_model, energy_levels; n = 0)
    states = nothing
    if energy_levels < 0
        error("cannot have a negative number of energy levels")
    elseif (ising_model == nothing && n == 0)
        error("both ising model and n were not specified, could not compute states")
    elseif ising_model == nothing && energy_levels != 0
        error("must provide ising model if energy_levels != 0")
    elseif ising_model != nothing && energy_levels != 0
        energies = _QA.compute_ising_energy_levels(ising_model)
        energy_levels = min(energy_levels, length(energies))

        states = sort(collect(foldl(union, [energies[i].states for i = 1:energy_levels])))
    else
        if n == 0
            n = _QA._check_ising_model_ids(ising_model)
        end
        states = 0:2^n-1
    end
    return states
end
