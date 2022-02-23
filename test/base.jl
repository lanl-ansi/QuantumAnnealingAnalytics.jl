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
