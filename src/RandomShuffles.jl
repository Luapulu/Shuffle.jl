## FisherYates ##

"""
    FisherYates()

[Fisher-Yates shuffling algorithm](https://en.wikipedia.org/wiki/Fisher–Yates_shuffle) as
implemented by [`Random.shuffle`](https://docs.julialang.org/en/v1/stdlib/Random/#Random.shuffle).

# Examples
```jldoctest
julia> mt1 = MersenneTwister(1234); mt2 = MersenneTwister(1234);

julia> Shuffle.shuffle(mt1, collect(1:100), FisherYates()) == Random.shuffle(mt2, collect(1:100))
true
```
"""
struct FisherYates <: RandomShuffle end

shuffle!(r::AbstractRNG, c::AbstractArray, s::FisherYates) = Random.shuffle!(r, c)

## GilbertShannonReeds ##

"""
    GilbertShannonReeds()

[Gilbert-Shannon-Reeds shuffling algorithm](https://en.wikipedia.org/wiki/Gilbert–Shannon–Reeds_model).

# Examples
```jldoctest
julia> mt = MersenneTwister(1234);

julia> nshuffle(mt, collect(1:7), 7, GilbertShannonReeds())
7-element Array{Int64,1}:
 6
 1
 7
 3
 5
 4
 2
```
"""
struct GilbertShannonReeds <: RandomShuffle end

function shuffle(
    r::AbstractRNG,
    c::AbstractArray,
    s::GilbertShannonReeds,
    out::AbstractArray = similar(c),
)
    length(out) == length(c) || error("array lengths c and out must equal")

    # flip a coin to determine from which pile each item will come
    flips = rand(r, Bool, length(c))

    # positions in the collection for the first and second pile
    swtch = [1, count(flips) + 1]

    # Get item from respective pile and increment position in collection for each item
    for (i, frmfirst) in enumerate(flips)
        pidx = 2 - frmfirst
        @inbounds begin
            out[i] = c[swtch[pidx]]
            swtch[pidx] += 1
        end
    end

    return out
end

function nshuffle!(r::AbstractRNG, c::AbstractArray, n::Integer, s::GilbertShannonReeds)
    tmp = similar(c)

    for i in 1:fld(n, 2)
        shuffle(r, c, s, tmp)
        shuffle(r, tmp, s, c)
    end

    if isodd(n)
        return shuffle(r, c, s, tmp)
    else
        return c
    end
end
