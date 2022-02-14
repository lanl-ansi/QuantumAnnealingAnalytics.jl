module QuantumAnnealingAnalytics
    import Plots
    import Plots.Measures
    import QuantumAnnealing
    import JSON
    const _QA = QuantumAnnealing

    include("base.jl")
    include("plot.jl")
    include("export.jl")

    import Plots: savefig
    export savefig

end  #module
