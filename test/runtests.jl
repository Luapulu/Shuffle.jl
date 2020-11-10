using Test, Shuffle, Documenter, OffsetArrays
using Random: MersenneTwister, default_rng

@testset "Shuffle.jl" begin

include("shuffles.jl")

include("defaults.jl")

if false
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

    doctest(Shuffle)
end

end
