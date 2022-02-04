function plot_annealing_schedule(annealing_schedule::QuantumAnnealing.AnnealingSchedule;units="GHz")
    ss = 0.0:0.001:1.0
    plt = Plots.plot(ss,annealing_schedule.A,title="Annealing Schedule",xlabel = "s", ylabel = units, label = "A(s)")
    Plots.plot!(ss,annealing_schedule.B,label="B(s)")
    return plt
end

function plot_states(ρ;order=:numeric,ising_comp=ones(Int(log2(size(ρ)[1]))),num_states=16)
    state_probs = QuantumAnnealing.z_measure_probabilities(ρ)
    n = Int(log2(length(state_probs)))
    state_ising_vecs = map((x) -> int2ising(x,pad=n), 0:2^n-1)

    states = [(prob = state_probs[i], ising_vec = state_ising_vecs[i]) for i = 1:length(state_probs)]

    sortby = nothing
    if order == :numeric
        sortby = (x) -> ising2int(x.ising_vec)
    elseif order == :hamming
        if length(ising_comp) != n
            error("invalid ising_comp length")
        end
        sortby = (x) -> ising_hamming_distance(x.ising_vec, ising_comp)
    elseif order == :prob
        #sorting highest to lowest prob
        sortby = (x) -> -x.prob
    else
        error("order must be either :numeric or :hamming or :prob")
    end

    states = sort(states, by=sortby)
    probs = [states[i].prob for i = 1:length(states)]
    strings = map(x -> join(string.(x.ising_vec),"\n"), states)

    num_states = min(num_states, length(states))
    mm = Measures.mm
    plt = Plots.bar(probs[1:num_states], xticks = (1:num_states,strings[1:num_states]),
                    size = (900,600),bottom_margin=10mm, xlabel="ising state",
                    ylabel = "prob",title="State Probabilities of ρ",label="prob",
                    legend = :topright)
    return plt
end


function plot_ground_states_dwisc(dw::String; kwargs...)
    if isfile(dw)
        dwisc_data = JSON.parsefile(dw)
    else
        dwisc_data = JSON.parse(dw)
    end

    return plot_ground_states_dwisc(dwisc_data; kwargs...)
end

function plot_ground_states_dwisc(dw::Dict{String,<:Any}; order=:numeric, ising_comp=[])
    least_energy = dwisc["solutions"][1]["energy"]
    groundstates = filter(x -> x["energy"] ≈ least_energy,dwisc["solutions"])

    n = length(groundstates[1]["solution"])

    sortby = nothing
    if order == :numeric
        sortby = (x) -> ising2int(x["solution"])
    elseif order == :hamming
        if ising_comp == []
            ising_comp = ones(n)
        elseif length(ising_comp) != n
            error("invalid ising_comp length")
        end
        sortby = (x) -> ising_hamming_distance(x["solution"], ising_comp)
    else
        error("order must be either :numeric or :hamming")
    end

    groundstates = sort(groundstates, by=sortby)
    groundprobs = nothing
    if "prob" in keys(groundstates[1])
        groundprobs = map(x -> x["prob"], groundstates)
    else
        shots = map(x -> x["num_occurrences"],dwisc["solutions"])
        numshots = sum(shots)
        groundprobs = map(x -> x["num_occurrences"]/numshots, groundstates)
    end
    groundstrings = map(x -> join(string.(x["solution"]),"\n"), groundstates)
    mm = Measures.mm
    plt = Plots.bar(groundprobs, xticks = (1:length(groundprobs),groundstrings), size = (900,600),bottom_margin=10mm,
              xlabel="ising state", ylabel = "prob",title="Ground States, Energy = $least_energy",label="prob",
              legend = :topright)
    return plt
end


function plot_states_dwisc(dw::String; kwargs...)
    if isfile(dw)
        dwisc_data = JSON.parsefile(dw)
    else
        dwisc_data = JSON.parse(dw)
    end

    return plot_states_dwisc(dwisc_data; kwargs...)
end

function plot_states_dwisc(dw::Dict{String,<:Any}; order=:numeric, ising_comp=[], num_states=16)
    least_energy = dwisc["solutions"][1]["energy"]
    states = dwisc["solutions"]

    n = length(states[1]["solution"])
    sortby = nothing
    if order == :numeric
        sortby = (x) -> ising2int(x["solution"])
    elseif order == :hamming
        if ising_comp == []
            ising_comp = ones(n)
        elseif length(ising_comp) != n
            error("invalid ising_comp length")
        end
        sortby = (x) -> ising_hamming_distance(x["solution"], ising_comp)
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
        shots = map(x -> x["num_occurrences"],dwisc["solutions"])
        numshots = sum(shots)
        probs = map(x -> x["num_occurrences"]/numshots, states)
    end
    strings = map(x -> join(string.(x["solution"]),"\n"), states)
    mm = Measures.mm

    num_states = min(length(states),num_states)

    plt = Plots.bar(probs[1:num_states], xticks = (1:num_states,strings[1:num_states]),
                    size = (900,600),bottom_margin=10mm, xlabel="ising state",
                    ylabel = "prob",title="States, Least Energy = $least_energy",label="prob",
                    legend = :topright)
    return plt
end
