@testset "state encoding and transformation" begin

    @testset "spin2int" begin
        @test spin2int([1, 1, 1]) == 0
        @test spin2int([-1, 1, 1]) == 1
        @test spin2int([1, -1, 1]) == 2
        @test spin2int([1, 1, -1]) == 4
    end

    @testset "int2spin" begin
        @test int2spin(0,pad=3) == [1, 1, 1]
        @test int2spin(1,pad=3) == [-1, 1, 1]
        @test int2spin(2,pad=3) == [1, -1, 1]
        @test int2spin(4,pad=3) == [1, 1, -1]
    end

    @testset "spin2binary" begin
        @test spin2binary([1, 1, 1]) == [0, 0, 0]
        @test spin2binary([-1, 1, 1]) == [1, 0, 0]
        @test spin2binary([1, -1, 1]) == [0, 1, 0]
        @test spin2binary([1, 1, -1]) == [0, 0, 1]
    end

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
