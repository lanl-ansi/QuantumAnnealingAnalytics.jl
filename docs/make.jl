using Documenter, QuantumAnnealingAnalytics

makedocs(
    modules = [QuantumAnnealingAnalytics],
    sitename = "QuantumAnnealingAnalytics",
    authors = "Zach Morrell, Carleton Coffrin, Marc Vuffray",
    pages = [
        "Home" => "index.md",
        "Library" => "api.md"
    ]
)

deploydocs(
    repo = "github.com/lanl-ansi/QuantumAnnealingAnalytics.jl.git",
)
