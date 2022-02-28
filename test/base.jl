@testset "state encoding and transformation" begin

    @testset "spin_hamming_distance" begin
        @test spin_hamming_distance([1, 1, 1], [1, 1, 1]) == 0
        @test spin_hamming_distance([1, 1, 1], [-1, 1, 1]) == 1
        @test spin_hamming_distance([1, 1, 1], [1, -1, 1]) == 1
        @test spin_hamming_distance([1, 1, 1], [1, 1, -1]) == 1
        @test spin_hamming_distance([1, 1, 1], [1, -1, -1]) == 2
        @test spin_hamming_distance([1, 1, 1], [-1, 1, -1]) == 2
        @test spin_hamming_distance([1, 1, 1], [-1, -1, 1]) == 2
        @test spin_hamming_distance([1, 1, 1], [-1, -1, -1]) == 3
        @test spin_hamming_distance([-1, -1, -1], [1, 1, 1]) == 3
        @test spin_hamming_distance([-1, -1, -1], [-1, 1, 1]) == 2
        @test spin_hamming_distance([-1, -1, -1], [1, -1, 1]) == 2
        @test spin_hamming_distance([-1, -1, -1], [1, 1, -1]) == 2
        @test spin_hamming_distance([-1, -1, -1], [1, -1, -1]) == 1
        @test spin_hamming_distance([-1, -1, -1], [-1, 1, -1]) == 1
        @test spin_hamming_distance([-1, -1, -1], [-1, -1, 1]) == 1
        @test spin_hamming_distance([-1, -1, -1], [-1, -1, -1]) == 0
    end

end

@testset "get_states functionality" begin
    ising_model = nothing; energy_levels = 0; n = 0
    try
        states = QuantumAnnealingAnalytics._get_states(ising_model, energy_levels, n = n)
        @test false
    catch
        @test true
    end

    ising_model = nothing; energy_levels = 0; n = 2
    states = QuantumAnnealingAnalytics._get_states(ising_model, energy_levels, n = n)
    @test states == [0, 1, 2, 3]

    ising_model = nothing; energy_levels = 1; n = 0
    try
        states = QuantumAnnealingAnalytics._get_states(ising_model, energy_levels, n = n)
        @test false
    catch
        @test true
    end

    ising_model = nothing; energy_levels = 1; n = 2
    try
        states = QuantumAnnealingAnalytics._get_states(ising_model, energy_levels, n = n)
        @test false
    catch
        @test true
    end

    ising_model = Dict((1,) => 1, (2,) => 1); energy_levels = 0; n = 0
    states = QuantumAnnealingAnalytics._get_states(ising_model, energy_levels, n = n)
    @test states == [0, 1, 2, 3]

    ising_model = Dict((1,) => 1, (2,) => 1); energy_levels = 0; n = 2
    states = QuantumAnnealingAnalytics._get_states(ising_model, energy_levels, n = n)
    @test states == [0, 1, 2, 3]

    ising_model = Dict((1,) => 1, (2,) => 1); energy_levels = 1; n = 0
    states = QuantumAnnealingAnalytics._get_states(ising_model, energy_levels, n = n)
    @test states == [3]

    ising_model = Dict((1,) => 1, (2,) => 1); energy_levels = 1; n = 2
    states = QuantumAnnealingAnalytics._get_states(ising_model, energy_levels, n = n)
    @test states == [3]


    ising_model = nothing; energy_levels = -1; n = 2
    try
        states = QuantumAnnealingAnalytics._get_states(ising_model, energy_levels, n = n)
        @test false
    catch
        @test true
    end

    ising_model = Dict((1,) => 1, (2,) => 1); energy_levels = 10; n = 0
    states = QuantumAnnealingAnalytics._get_states(ising_model, energy_levels, n = n)
    @test states == [0, 1, 2, 3]
end
