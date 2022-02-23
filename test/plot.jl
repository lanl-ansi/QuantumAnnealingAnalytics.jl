single_qubit_dwisc_file = "data/dwisc_1q.json"
two_qubit_dwisc_file = "data/dwisc_2q.json"

single_qubit_dwisc_dict = JSON.parsefile(single_qubit_dwisc_file)
two_qubit_dwisc_dict = JSON.parsefile(two_qubit_dwisc_file)

single_qubit_dwisc_string = JSON.json(single_qubit_dwisc_dict)
two_qubit_dwisc_string = JSON.json(two_qubit_dwisc_dict)

#just testing that nothing errors out
@testset "plotting annealing schedule" begin
    @testset "AS_CIRCULAR, no kwargs" begin
        plt = plot_annealing_schedule(AS_CIRCULAR)
        @test true
    end

    @testset "AS_CIRCULAR, kwargs" begin
        plt = plot_annealing_schedule(AS_CIRCULAR,xlabel="x")
        @test true
    end
end

@testset "plotting states from ising dict, 1q" begin
    ising = Dict((1,) => 1)
    ρ = simulate(ising, 100, AS_CIRCULAR, 100)

    @testset "single qubit plot, numeric sorting, no kwargs" begin
        plt = plot_states(ρ,order=:numeric)
        @test true
    end

    @testset "single qubit plot, hamming sorting, no kwargs" begin
        plt = plot_states(ρ,order=:hamming)
        @test true
        plt = plot_states(ρ,order=:hamming,spin_comp=[-1])
        @test true
    end

    @testset "single qubit plot, prob sorting, no kwargs" begin
        plt = plot_states(ρ,order=:prob)
        @test true
    end

    @testset "single qubit plot, numeric sorting, with kwargs" begin
        plt = plot_states(ρ,order=:numeric,xlabel="x")
        @test true
    end

    @testset "single qubit plot, hamming sorting, with kwargs" begin
        plt = plot_states(ρ,order=:hamming,xlabel="x")
        @test true
        plt = plot_states(ρ,order=:hamming,spin_comp=[-1],xlabel="x")
        @test true
    end

    @testset "single qubit plot, prob sorting, with kwargs" begin
        plt = plot_states(ρ,order=:prob,xlabel="x")
        @test true
    end
end

@testset "plotting states from ising dict, 2q" begin
    ising = Dict((1,) => 1, (2,) => 1, (1,2) => -1)
    ρ = simulate(ising, 100, AS_CIRCULAR, 100)

    @testset "two qubit plot, numeric sorting, no kwargs" begin
        plt = plot_states(ρ,order=:numeric)
        @test true
    end

    @testset "two qubit plot, hamming sorting, no kwargs" begin
        plt = plot_states(ρ,order=:hamming)
        @test true
        plt = plot_states(ρ,order=:hamming,spin_comp=[-1, -1])
        @test true
    end

    @testset "two qubit plot, prob sorting, no kwargs" begin
        plt = plot_states(ρ,order=:prob)
        @test true
    end

    @testset "two qubit plot, numeric sorting, with kwargs" begin
        plt = plot_states(ρ,order=:numeric,xlabel="x")
        @test true
    end

    @testset "two qubit plot, hamming sorting, with kwargs" begin
        plt = plot_states(ρ,order=:hamming,xlabel="x")
        @test true
        plt = plot_states(ρ,order=:hamming,spin_comp=[-1,-1],xlabel="x")
        @test true
    end

    @testset "two qubit plot, prob sorting, with kwargs" begin
        plt = plot_states(ρ,order=:prob,xlabel="x")
        @test true
    end
end

@testset "plotting from dwisc file" begin
    @testset "single qubit dwisc, ground states, numeric sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_file,order=:numeric)
        @test true
    end

    @testset "single qubit dwisc, all states, numeric sorting, no kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_file,order=:numeric)
        @test true
    end

    @testset "single qubit dwisc, ground states, hamming sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_file,order=:hamming)
        @test true
        plt = plot_ground_states_dwisc(single_qubit_dwisc_file,order=:hamming,spin_comp=[-1])
        @test true
    end

    @testset "single qubit dwisc, all states, hamming sorting, no kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_file,order=:hamming)
        @test true
        plt = plot_states_dwisc(single_qubit_dwisc_file,order=:hamming, spin_comp=[-1])
        @test true
    end

    @testset "single qubit dwisc, ground states, prob sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_file,order=:prob)
        @test true
    end

    @testset "single qubit dwisc, all states, prob sorting, no kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_file,order=:prob)
        @test true
    end

    @testset "single qubit dwisc, ground states, numeric sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_file,order=:numeric, xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, all states, numeric sorting, with kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_file,order=:numeric, xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, ground states, hamming sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_file,order=:hamming, xlabel="x")
        @test true
        plt = plot_ground_states_dwisc(single_qubit_dwisc_file,order=:hamming,spin_comp=[-1], xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, all states, hamming sorting, with kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_file,order=:hamming, xlabel="x")
        @test true
        plt = plot_states_dwisc(single_qubit_dwisc_file,order=:hamming, spin_comp=[-1], xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, ground states, prob sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_file,order=:prob, xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, all states, prob sorting, with kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_file,order=:prob, xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, ground states, numeric sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_file,order=:numeric)
        @test true
    end

    @testset "two qubit dwisc, all states, numeric sorting, no kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_file,order=:numeric)
        @test true
    end

    @testset "two qubit dwisc, ground states, hamming sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_file,order=:hamming)
        @test true
        plt = plot_ground_states_dwisc(two_qubit_dwisc_file,order=:hamming,spin_comp=[-1,-1])
        @test true
    end

    @testset "two qubit dwisc, all states, hamming sorting, no kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_file,order=:hamming)
        @test true
        plt = plot_states_dwisc(two_qubit_dwisc_file,order=:hamming, spin_comp=[-1,-1])
        @test true
    end

    @testset "two qubit dwisc, ground states, prob sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_file,order=:prob)
        @test true
    end

    @testset "two qubit dwisc, all states, prob sorting, no kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_file,order=:prob)
        @test true
    end

    @testset "two qubit dwisc, ground states, numeric sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_file,order=:numeric, xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, all states, numeric sorting, with kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_file,order=:numeric, xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, ground states, hamming sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_file,order=:hamming, xlabel="x")
        @test true
        plt = plot_ground_states_dwisc(two_qubit_dwisc_file,order=:hamming,spin_comp=[-1,-1], xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, all states, hamming sorting, with kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_file,order=:hamming, xlabel="x")
        @test true
        plt = plot_states_dwisc(two_qubit_dwisc_file,order=:hamming, spin_comp=[-1,-1], xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, ground states, prob sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_file,order=:prob, xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, all states, prob sorting, with kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_file,order=:prob, xlabel="x")
        @test true
    end
end

@testset "plotting from dwisc dict" begin
    @testset "single qubit dwisc, ground states, numeric sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_dict,order=:numeric)
        @test true
    end

    @testset "single qubit dwisc, all states, numeric sorting, no kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_dict,order=:numeric)
        @test true
    end

    @testset "single qubit dwisc, ground states, hamming sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_dict,order=:hamming)
        @test true
        plt = plot_ground_states_dwisc(single_qubit_dwisc_dict,order=:hamming,spin_comp=[-1])
        @test true
    end

    @testset "single qubit dwisc, all states, hamming sorting, no kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_dict,order=:hamming)
        @test true
        plt = plot_states_dwisc(single_qubit_dwisc_dict,order=:hamming, spin_comp=[-1])
        @test true
    end

    @testset "single qubit dwisc, ground states, prob sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_dict,order=:prob)
        @test true
    end

    @testset "single qubit dwisc, all states, prob sorting, no kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_dict,order=:prob)
        @test true
    end

    @testset "single qubit dwisc, ground states, numeric sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_dict,order=:numeric, xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, all states, numeric sorting, with kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_dict,order=:numeric, xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, ground states, hamming sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_dict,order=:hamming, xlabel="x")
        @test true
        plt = plot_ground_states_dwisc(single_qubit_dwisc_dict,order=:hamming,spin_comp=[-1], xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, all states, hamming sorting, with kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_dict,order=:hamming, xlabel="x")
        @test true
        plt = plot_states_dwisc(single_qubit_dwisc_dict,order=:hamming, spin_comp=[-1], xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, ground states, prob sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_dict,order=:prob, xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, all states, prob sorting, with kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_dict,order=:prob, xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, ground states, numeric sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_dict,order=:numeric)
        @test true
    end

    @testset "two qubit dwisc, all states, numeric sorting, no kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_dict,order=:numeric)
        @test true
    end

    @testset "two qubit dwisc, ground states, hamming sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_dict,order=:hamming)
        @test true
        plt = plot_ground_states_dwisc(two_qubit_dwisc_dict,order=:hamming,spin_comp=[-1,-1])
        @test true
    end

    @testset "two qubit dwisc, all states, hamming sorting, no kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_dict,order=:hamming)
        @test true
        plt = plot_states_dwisc(two_qubit_dwisc_dict,order=:hamming, spin_comp=[-1,-1])
        @test true
    end

    @testset "two qubit dwisc, ground states, prob sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_dict,order=:prob)
        @test true
    end

    @testset "two qubit dwisc, all states, prob sorting, no kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_dict,order=:prob)
        @test true
    end

    @testset "two qubit dwisc, ground states, numeric sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_dict,order=:numeric, xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, all states, numeric sorting, with kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_dict,order=:numeric, xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, ground states, hamming sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_dict,order=:hamming, xlabel="x")
        @test true
        plt = plot_ground_states_dwisc(two_qubit_dwisc_dict,order=:hamming,spin_comp=[-1,-1], xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, all states, hamming sorting, with kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_dict,order=:hamming, xlabel="x")
        @test true
        plt = plot_states_dwisc(two_qubit_dwisc_dict,order=:hamming, spin_comp=[-1,-1], xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, ground states, prob sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_dict,order=:prob, xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, all states, prob sorting, with kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_dict,order=:prob, xlabel="x")
        @test true
    end

end

@testset "plotting from dwisc string" begin
    @testset "single qubit dwisc, ground states, numeric sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_string,order=:numeric)
        @test true
    end

    @testset "single qubit dwisc, all states, numeric sorting, no kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_string,order=:numeric)
        @test true
    end

    @testset "single qubit dwisc, ground states, hamming sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_string,order=:hamming)
        @test true
        plt = plot_ground_states_dwisc(single_qubit_dwisc_string,order=:hamming,spin_comp=[-1])
        @test true
    end

    @testset "single qubit dwisc, all states, hamming sorting, no kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_string,order=:hamming)
        @test true
        plt = plot_states_dwisc(single_qubit_dwisc_string,order=:hamming, spin_comp=[-1])
        @test true
    end

    @testset "single qubit dwisc, ground states, prob sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_string,order=:prob)
        @test true
    end

    @testset "single qubit dwisc, all states, prob sorting, no kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_string,order=:prob)
        @test true
    end

    @testset "single qubit dwisc, ground states, numeric sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_string,order=:numeric, xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, all states, numeric sorting, with kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_string,order=:numeric, xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, ground states, hamming sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_string,order=:hamming, xlabel="x")
        @test true
        plt = plot_ground_states_dwisc(single_qubit_dwisc_string,order=:hamming,spin_comp=[-1], xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, all states, hamming sorting, with kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_string,order=:hamming, xlabel="x")
        @test true
        plt = plot_states_dwisc(single_qubit_dwisc_string,order=:hamming, spin_comp=[-1], xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, ground states, prob sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(single_qubit_dwisc_string,order=:prob, xlabel="x")
        @test true
    end

    @testset "single qubit dwisc, all states, prob sorting, with kwargs" begin
        plt = plot_states_dwisc(single_qubit_dwisc_string,order=:prob, xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, ground states, numeric sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_string,order=:numeric)
        @test true
    end

    @testset "two qubit dwisc, all states, numeric sorting, no kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_string,order=:numeric)
        @test true
    end

    @testset "two qubit dwisc, ground states, hamming sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_string,order=:hamming)
        @test true
        plt = plot_ground_states_dwisc(two_qubit_dwisc_string,order=:hamming,spin_comp=[-1,-1])
        @test true
    end

    @testset "two qubit dwisc, all states, hamming sorting, no kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_string,order=:hamming)
        @test true
        plt = plot_states_dwisc(two_qubit_dwisc_string,order=:hamming, spin_comp=[-1,-1])
        @test true
    end

    @testset "two qubit dwisc, ground states, prob sorting, no kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_string,order=:prob)
        @test true
    end

    @testset "two qubit dwisc, all states, prob sorting, no kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_string,order=:prob)
        @test true
    end

    @testset "two qubit dwisc, ground states, numeric sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_string,order=:numeric, xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, all states, numeric sorting, with kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_string,order=:numeric, xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, ground states, hamming sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_string,order=:hamming, xlabel="x")
        @test true
        plt = plot_ground_states_dwisc(two_qubit_dwisc_string,order=:hamming,spin_comp=[-1,-1], xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, all states, hamming sorting, with kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_string,order=:hamming, xlabel="x")
        @test true
        plt = plot_states_dwisc(two_qubit_dwisc_string,order=:hamming, spin_comp=[-1,-1], xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, ground states, prob sorting, with kwargs" begin
        plt = plot_ground_states_dwisc(two_qubit_dwisc_string,order=:prob, xlabel="x")
        @test true
    end

    @testset "two qubit dwisc, all states, prob sorting, with kwargs" begin
        plt = plot_states_dwisc(two_qubit_dwisc_string,order=:prob, xlabel="x")
        @test true
    end

end

@testset "plotting single qubit state steps" begin
    state_steps = []
    ising = Dict((1,) => 1)
    ρ = simulate(ising, 100, AS_CIRCULAR, 100, state_steps=state_steps)

    @testset "single qubit, no kwargs" begin
        plt = plot_state_steps(state_steps)
        @test true
    end

    @testset "single qubit, with kwargs" begin
        plt = plot_state_steps(state_steps,xlabel="x")
        @test true
    end

end

@testset "plotting single qubit state steps" begin
    state_steps = []
    ising = Dict((1,) => 1, (2,) => 1, (1,2) => -1)
    ρ = simulate(ising, 100, AS_CIRCULAR, 100, state_steps=state_steps)

    @testset "single qubit, no kwargs" begin
        plt = plot_state_steps(state_steps)
        @test true
    end

    @testset "single qubit, with kwargs" begin
        plt = plot_state_steps(state_steps,xlabel="x")
        @test true
    end

end

@testset "plotting hamiltonian energy spectrum" begin
    ising_model = Dict((1,) => 1, (2,) => -.25, (1,2) => -.9)
    H(s) = transverse_ising_hamiltonian(ising_model, AS_CIRCULAR, s)
    @testset "No parameters" begin
        plt = plot_hamiltonian_energy_spectrum(H)
        @test true
    end
    @testset "Changing kwargs" begin
        plt = plot_hamiltonian_energy_spectrum(H, xlabel = "x")
        @test true
    end
    @testset "changing s_range" begin
        plt = plot_hamiltonian_energy_spectrum(H, s_range=(0.5,0.7))
        @test true
    end
end
