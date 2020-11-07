using Documenter, Shuffle

DocMeta.setdocmeta!(
    Shuffle,
    :DocTestSetup,
    quote
        using Shuffle
        using Random: MersenneTwister
    end;
    recursive=true
)

makedocs(
    sitename = "Shuffle.jl",
    modules = [Shuffle],
    pages = [
        "Home" => "index.md"
        "API Reference" => "reference.md"
    ],
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true"
    )
)

deploydocs(
    repo = "github.com/Luapulu/Shuffle.jl.git",
    devbranch = "main"
)
