"""
function to plot an annealing schedule from QuantumAnnealing.jl.  kwargs are for Plots.plot
"""
function plot_annealing_schedule(annealing_schedule::QuantumAnnealing.AnnealingSchedule;units="GHz", kwargs...)
    ss = 0.0:0.001:1.0
    plotted = hcat(annealing_schedule.A.(ss), annealing_schedule.B.(ss))
    plt = Plots.plot(ss, plotted; title="Annealing Schedule", xlabel = "s", ylabel = units, label = ["A(s)" "B(s)"], kwargs...)
    return plt
end


"""
function to plot the states present in a density matrix output by QuantumAnnealing.simulate
kwargs are for Plots.bar
"""
function plot_states(ρ;order=:numeric,spin_comp=ones(Int(log2(size(ρ)[1]))),num_states=16, kwargs...)
    state_probs = QuantumAnnealing.z_measure_probabilities(ρ)
    n = Int(log2(length(state_probs)))
    state_spin_vecs = map((x) -> int2spin(x,pad=n), 0:2^n-1)

    states = [(prob = state_probs[i], spin_vec = state_spin_vecs[i]) for i = 1:length(state_probs)]

    sortby = nothing
    if order == :numeric
        sortby = (x) -> spin2int(x.spin_vec)
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
                    legend = :topright, kwargs...)
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
        sortby = (x) -> spin2int(x["solution"])
    elseif order == :hamming
        if spin_comp == []
            spin_comp = ones(n)
        elseif length(spin_comp) != n
            error("invalid spin_comp length")
        end
        sortby = (x) -> spin_hamming_distance(x["solution"], spin_comp)
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
              legend = :topright, kwargs...)
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
        sortby = (x) -> spin2int(x["solution"])
    elseif order == :hamming
        if spin_comp == []
            spin_comp = ones(n)
        elseif length(spin_comp) != n
            error("invalid spin_comp length")
        end
        sortby = (x) -> spin_hamming_distance(x["solution"], spin_comp)
    elseif order == :energy
        sortby = (x) -> x["energy"]
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
                    legend = :topright, kwargs...)
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

    int2braket(i) = QuantumAnnealing.spin2braket(QuantumAnnealing.binary2spin(QuantumAnnealing.int2binary(i,pad=n)))
    labels = map(int2braket, reshape(0:2^n-1,1,:))

    xlabel = "s"
    ylabel = "prob"
    title = "Spin Trajectories"
    legend = :right
    plt = Plots.plot(ss, plotted_states'; title=title, label=labels, xlabel=xlabel, ylabel=ylabel, legend=legend, kwargs...)
    return plt
end

