using Documenter, Shuffle

DocMeta.setdocmeta!(
    Shuffle,
    :DocTestSetup,
    quote
        using Shuffle
        import Random
        using Random: MersenneTwister
    end;
    recursive=true
)

makedocs(
    sitename = "Shuffle.jl",
    modules = [Shuffle],
    pages = [
        "Home" => "index.md"
        "Reference" => "reference.md"
    ],
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true"
    )
)

deploydocs(
    repo = "github.com/Luapulu/Shuffle.jl.git",
    devbranch = "main",
    versions = ["stable" => "v^", "v#.#.#", devurl => devurl]
)
