"""
function to plot an annealing schedule from QuantumAnnealing.jl.  kwargs are for Plots.plot
"""
function plot_annealing_schedule(annealing_schedule::_QA.AnnealingSchedule; s_steps=0.0:0.001:1.0, kwargs...)
    plotted = hcat(annealing_schedule.A.(s_steps), annealing_schedule.B.(s_steps))
    plt = Plots.plot(s_steps, plotted; title="Annealing Schedule", xlabel="s", label=["A(s)" "B(s)"], legend=:right, kwargs...)
    return plt
end


"""
function to plot the states present in a density matrix output by QuantumAnnealing.simulate
kwargs are for Plots.bar
"""
function plot_states(ρ; order=:numeric, spin_comp=ones(Int(log2(size(ρ)[1]))), num_states=0, ising_model=nothing, energy_levels=0, kwargs...)
    state_probs = _QA.z_measure_probabilities(ρ)
    n = Int(log2(length(state_probs)))
    state_spin_vecs = map((x) -> _QA.int_to_spin(x,pad=n), 0:2^n-1)

    states = [(prob = state_probs[i], spin_vec = state_spin_vecs[i]) for i = 1:length(state_probs)]

    sortby = nothing
    if order == :numeric
        sortby = (x) -> _QA.spin_to_int(x.spin_vec)
    elseif order == :hamming
        if length(spin_comp) != n
            error("invalid spin_comp length")
        end
        sortby = (x) -> spin_hamming_distance(x.spin_vec, spin_comp)
    elseif order == :prob
        #sorting highest to lowest prob
        sortby = (x) -> -x.prob
    else
        error("order must be either :numeric or :hamming or :prob")
    end

    kept_states = _get_states(ising_model, energy_levels, n = n)
    filter_function = (x) -> _QA.spin_to_int(x.spin_vec) in kept_states
    states = filter(filter_function, states)

    states = sort(states, by=sortby)
    probs = [states[i].prob for i = 1:length(states)]
    strings = map(x -> join(string.(x.spin_vec),"\n"), states)

    num_state_bars = length(states)
    if num_states > 0 
        num_state_bars = min(num_states, num_state_bars)
    end
    mm = Measures.mm
    plt = Plots.bar(probs[1:num_state_bars]; xticks = (1:num_state_bars,strings[1:num_state_bars]),
        size = (900,600),bottom_margin=10mm, xlabel="spin state",
        ylabel = "probability",title="State Probabilities of ρ",label="prob",
        legend = :none, kwargs...
    )
    return plt
end

"""
function to plot only the lowest energy states in a dwisc bqpjson format file, String, or Dict.
possible orderings are :numeric or :hamming.  spin_comp specifies a state in spin format
for comparison in hamming distance calculations. kwargs is for Plots.bar
"""
function plot_ground_states_dwisc(dw::String; kwargs...)
    if length(dw) <= 255 && isfile(dw)
        dwisc_data = JSON.parsefile(dw)
    else
        dwisc_data = JSON.parse(dw)
    end
    return plot_ground_states_dwisc(dwisc_data; kwargs...)
end

function plot_ground_states_dwisc(dw::Dict{String,<:Any}; order=:numeric, spin_comp=[], kwargs...)
    least_energy = dw["solutions"][1]["energy"]
    groundstates = filter(x -> x["energy"] ≈ least_energy,dw["solutions"])

    n = length(groundstates[1]["solution"])

    sortby = nothing
    if order == :numeric
        sortby = (x) -> _QA.spin_to_int(x["solution"])
    elseif order == :hamming
        if spin_comp == []
            spin_comp = ones(n)
        elseif length(spin_comp) != n
            error("invalid spin_comp length")
        end
        sortby = (x) -> spin_hamming_distance(x["solution"], spin_comp)
    elseif order == :prob
        sortby = (x) -> -x["num_occurrences"]
    else
        error("order must be either :numeric or :hamming")
    end

    groundstates = sort(groundstates, by=sortby)
    groundprobs = nothing
    if "prob" in keys(groundstates[1])
        groundprobs = map(x -> x["prob"], groundstates)
    else
        shots = map(x -> x["num_occurrences"],dw["solutions"])
        numshots = sum(shots)
        groundprobs = map(x -> x["num_occurrences"]/numshots, groundstates)
    end
    groundstrings = map(x -> join(string.(x["solution"]),"\n"), groundstates)
    mm = Measures.mm
    plt = Plots.bar(groundprobs; xticks = (1:length(groundprobs),groundstrings), size = (900,600),bottom_margin=10mm,
              xlabel="spin state", ylabel = "probability",title="Ground States, Energy = $least_energy",label="prob",
              legend = :none, kwargs...)
    return plt
end

"""
function to plot only the all states in a dwisc bqpjson format file, String, or Dict.
possible orderings are :numeric, :hamming, or :energy.  spin_comp specifies a state in spin format
for comparison in hamming distance calculations. kwargs is for Plots.bar
"""
function plot_states_dwisc(dw::String; kwargs...)
    if length(dw) <= 255 && isfile(dw)
        dwisc_data = JSON.parsefile(dw)
    else
        dwisc_data = JSON.parse(dw)
    end
    return plot_states_dwisc(dwisc_data; kwargs...)
end

function plot_states_dwisc(dw::Dict{String,<:Any}; order=:numeric, spin_comp=[], num_states=16, kwargs...)
    least_energy = dw["solutions"][1]["energy"]
    states = dw["solutions"]

    n = length(states[1]["solution"])
    sortby = nothing
    if order == :numeric
        sortby = (x) -> _QA.spin_to_int(x["solution"])
    elseif order == :hamming
        if spin_comp == []
            spin_comp = ones(n)
        elseif length(spin_comp) != n
            error("invalid spin_comp length")
        end
        sortby = (x) -> spin_hamming_distance(x["solution"], spin_comp)
    elseif order == :energy
        sortby = (x) -> x["energy"]
    elseif order == :prob
        sortby = (x) -> -x["num_occurrences"]
    else
        error("order must be :numeric, :hamming, or :energy")
    end

    states = sort(states, by=sortby)
    probs = nothing
    if "prob" in keys(states[1])
        probs = map(x -> x["prob"], states)
    else
        shots = map(x -> x["num_occurrences"],dw["solutions"])
        numshots = sum(shots)
        probs = map(x -> x["num_occurrences"]/numshots, states)
    end
    strings = map(x -> join(string.(x["solution"]),"\n"), states)
    mm = Measures.mm

    num_states = min(length(states),num_states)

    plt = Plots.bar(probs[1:num_states]; xticks = (1:num_states,strings[1:num_states]),
                    size = (900,600), bottom_margin=10mm, xlabel="spin state",
                    ylabel = "probability",title="States, Least Energy = $least_energy",label="prob",
                    legend = :none, kwargs...)
    return plt
end

"""
function to plot the state steps, generated from calling simulate(..., state_steps=[]).  This
is used to see instantaneous measurement values throughout the anneal.  kwargs are for Plots.plot
"""
function plot_state_steps(state_steps; ising_model=nothing, energy_levels=0, kwargs...)
    n = Int(log2(size(state_steps[1])[1]))
    ss = range(0,1,length=length(state_steps))

    state_probs = map(x -> [real(x[i,i]) for i = 1:2^n], state_steps)
    plotted_states = foldl(hcat,state_probs)

    kept_states = _get_states(ising_model, energy_levels, n = n)
    kept_indices = kept_states .+ 1

    int2braket(i) = _QA.spin_to_braket(_QA.int_to_spin(i,pad=n))
    labels = map(int2braket, reshape(kept_states,1,:))

    plotted_states = plotted_states[kept_indices,:]

    xlabel = "s"
    ylabel = "probability"
    title = "Spin State Trajectories"
    legend = :topleft
    plt = Plots.plot(ss, plotted_states'; title=title, label=labels, xlabel=xlabel, ylabel=ylabel, legend=legend, kwargs...)
    return plt
end

function plot_varied_time_simulations(ising_model::Dict, annealing_schedule::_QA.AnnealingSchedule, time_range::Tuple; num_points=50, xscale=:identity, energy_levels = 0, kwargs...)
    n = _QA._check_ising_model_ids(ising_model)
    plotted_values = zeros(num_points, 2^n)
    annealing_times = nothing
    if xscale == :identity
        annealing_times = range(time_range[1], time_range[2], length=num_points)
    elseif xscale == :log10
        lower = log10(time_range[1])
        upper = log10(time_range[2])
        exponents = range(lower,upper,length=num_points)
        annealing_times = 10 .^ exponents
    end

    for (i, annealing_time) in enumerate(annealing_times)
        ρ = _QA.simulate(ising_model, annealing_time, annealing_schedule, silence=true)
        probs = _QA.z_measure_probabilities(ρ)
        plotted_values[i,:] = probs
    end

    kept_states = _get_states(ising_model, energy_levels, n = n)
    kept_indices = kept_states .+ 1
    plotted_values = plotted_values[:,kept_indices]

    title = "Time Varying State Probabilities"
    xlabel = "annealing time"
    ylabel = "probability"

    int2braket(i) = _QA.spin_to_braket(_QA.int_to_spin(i,pad=n))
    labels = map(int2braket, reshape(kept_states,1,:))
    legend = :topleft
    plt = Plots.plot(annealing_times, plotted_values; title=title, xlabel=xlabel, ylabel=ylabel, label=labels, legend=legend, xscale=xscale, kwargs...)
    return plt
end

function plot_hamiltonian_energy_spectrum(hamiltonian::Function; s_range = (0,1), num_points = 50, shift=false, kwargs...)
    ss = range(s_range[1],s_range[2],length=num_points)
    n = size(hamiltonian(ss[1]))[1]

    energies = zeros(num_points, n)
    for (i,s) in enumerate(ss)
        hs = hamiltonian(s)
        evals, evecs = LinearAlgebra.eigen(Matrix(hs))
        energies[i,:] = evals
    end

    if shift
        ground_energies = energies[:,1]
        for i in 1:size(energies)[2]
            energies[:,i] = energies[:,i] - ground_energies
        end
    end

    title = "Time Varying Spectrum of H"
    xlabel = "s"
    ylabel = "energy"
    legend = :none

    plt = Plots.plot(ss, energies; title=title, xlabel=xlabel, ylabel=ylabel, legend=legend, kwargs...)
    return plt
end

function plot_ising_model(ising_model; color_nodes=true, curves=false, nodeshape=:circle, kwargs...)
    n = _QA._check_ising_model_ids(ising_model)
    edges = fill(0, (n,n))
    nodes = fill(0.0, n)
    edge_labels = Dict()
    for (k,v) in ising_model
        if length(k) == 1
            nodes[k[1]] = v
        elseif length(k) == 2
            edge_labels[k] = v
            edges[k[1],k[2]] = 1
            edges[k[2],k[1]] = 1
        else
            @warn("cannot display qubit couplings of more than two qubits, omitting coupling")
        end
    end
    nodecolor = 1
    if color_nodes
        color_options = Plots.palette([:blue, :white, :red], 21)
        color_choices = collect(color_options)
        for (i,node) in enumerate(nodes)
            color_val = round(node,digits=1)
            if color_val < -1
                color_val = -1
            elseif color_val > 1
                color_val = 1
            end
            color_index = round(Int64, ((color_val+1) * 10)+1)
            color_choices[i] = color_options[color_index]
        end
        nodecolor = color_choices
    end
    if length(edge_labels) == 0
        error("GraphRecipes.jl cannot currently take graphs without edges, so the ising model must have at least one nonzero coupling")
    end
    plt = GraphRecipes.graphplot(edges; nodecolor=nodecolor, names=nodes, curves=curves, edge_label=edge_labels, nodeshape=nodeshape, kwargs...)
    return plt
end
