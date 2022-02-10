using QuantumAnnealingAnalytics
import QuantumAnnealing
using JSON
using Test
const _QA = QuantumAnnealing

@testset "QuantumAnnealing" begin

    include("base.jl")

    include("plot.jl")

end
