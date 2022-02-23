"""
function to plot an annealing schedule from QuantumAnnealing.jl.  kwargs are for Plots.plot
"""
function plot_annealing_schedule(annealing_schedule::_QA.AnnealingSchedule;units="GHz", kwargs...)
    ss = 0.0:0.001:1.0
    plotted = hcat(annealing_schedule.A.(ss), annealing_schedule.B.(ss))
    plt = Plots.plot(ss, plotted; title="Annealing Schedule", xlabel="s", ylabel=units, label=["A(s)" "B(s)"], legend=:right, kwargs...)
    return plt
end


"""
function to plot the states present in a density matrix output by QuantumAnnealing.simulate
kwargs are for Plots.bar
"""
function plot_states(ρ;order=:numeric,spin_comp=ones(Int(log2(size(ρ)[1]))),num_states=16, kwargs...)
    state_probs = _QA.z_measure_probabilities(ρ)
    n = Int(log2(length(state_probs)))
    state_spin_vecs = map((x) -> _QA.int2spin(x,pad=n), 0:2^n-1)

    states = [(prob = state_probs[i], spin_vec = state_spin_vecs[i]) for i = 1:length(state_probs)]

    sortby = nothing
    if order == :numeric
        sortby = (x) -> _QA.spin2int(x.spin_vec)
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

    states = sort(states, by=sortby)
    probs = [states[i].prob for i = 1:length(states)]
    strings = map(x -> join(string.(x.spin_vec),"\n"), states)

    num_states = min(num_states, length(states))
    mm = Measures.mm
    plt = Plots.bar(probs[1:num_states]; xticks = (1:num_states,strings[1:num_states]),
                    size = (900,600),bottom_margin=10mm, xlabel="spin state",
                    ylabel = "prob",title="State Probabilities of ρ",label="prob",
                    legend = :none, kwargs...)
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
        sortby = (x) -> _QA.spin2int(x["solution"])
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
              xlabel="spin state", ylabel = "prob",title="Ground States, Energy = $least_energy",label="prob",
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
        sortby = (x) -> _QA.spin2int(x["solution"])
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
                    size = (900,600),bottom_margin=10mm, xlabel="spin state",
                    ylabel = "prob",title="States, Least Energy = $least_energy",label="prob",
                    legend = :none, kwargs...)
    return plt
end

"""
function to plot the state steps, generated from calling simulate(..., state_steps=[]).  This
is used to see instantaneous measurement values throughout the anneal.  kwargs are for Plots.plot
"""
function plot_state_steps(state_steps; kwargs...)
    n = Int(log2(size(state_steps[1])[1]))
    ss = range(0,1,length=length(state_steps))

    state_probs = map(x -> [real(x[i,i]) for i = 1:2^n], state_steps)
    plotted_states = foldl(hcat,state_probs)

    int2braket(i) = _QA.spin2braket(_QA.binary2spin(_QA.int2binary(i,pad=n)))
    labels = map(int2braket, reshape(0:2^n-1,1,:))

    xlabel = "s"
    ylabel = "prob"
    title = "Spin Trajectories"
    legend = :topleft
    plt = Plots.plot(ss, plotted_states'; title=title, label=labels, xlabel=xlabel, ylabel=ylabel, legend=legend, kwargs...)
    return plt
end

function plot_varied_time_simulations(ising_model::Dict, annealing_schedule::_QA.AnnealingSchedule, time_range::Tuple; num_points=50, xscale=:identity, kwargs...)
    n = _QA._check_ising_model_ids(ising_model)
    plotted_values = zeros(num_points, 2^n)
    annealing_times = nothing
    if xscale == :identity
        annealing_times = range(time_range[1], time_range[2], num_points)
    elseif xscale == :log10
        lower = log10(time_range[1])
        upper = log10(time_range[2])
        exponents = range(lower,upper,num_points)
        annealing_times = 10 .^ exponents
    end

    for (i, annealing_time) in enumerate(annealing_times)
        ρ = _QA.simulate(ising_model, annealing_time, annealing_schedule, silence=true)
        probs = _QA.z_measure_probabilities(ρ)
        plotted_values[i,:] = probs
    end

    title = "Time Sweep Probabilities"
    xlabel = "annealing time"
    ylabel = "prob"

    int2braket(i) = _QA.spin2braket(_QA.binary2spin(_QA.int2binary(i,pad=n)))
    labels = map(int2braket, reshape(0:2^n-1,1,:))
    legend = :right
    plt = Plots.plot(annealing_times, plotted_values; title=title, xlabel=xlabel, ylabel=ylabel, label = labels, legend=legend, xscale=xscale, kwargs...)
    return plt
end

function plot_hamiltonian_energy_spectrum(hamiltonian::Function; s_range = (0,1), num_points = 50, kwargs...)
    ss = range(s_range[1],s_range[2],num_points)
    n = size(hamiltonian(ss[1]))[1]

    energies = zeros(num_points, n)
    for (i,s) in enumerate(ss)
        hs = hamiltonian(s)
        evals, evecs = LinearAlgebra.eigen(Matrix(hs))
        energies[i,:] = evals
    end

    title = "Energy Spectrum of H(s)"
    xlabel = "s"
    ylabel = "energy"
    legend = false

    plt = Plots.plot(ss, energies; title=title, xlabel=xlabel, ylabel=ylabel, legend=legend, kwargs...)
    return plt
end

