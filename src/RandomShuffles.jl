## RandomShuffle ##

"""
    RandomShuffle

type with no fields representing a completely random shuffle, which is guaranteed to be
equivalent to [`Random.shuffle`](https://docs.julialang.org/en/v1/stdlib/Random/#Random.shuffle)).

This algorithm is set as the default. See [`DEFAULTS`](@ref) and has the singleton instance
[`randshuffle`](@ref).

# Examples
```jldoctest
julia> mt1 = MersenneTwister(1234); mt2 = MersenneTwister(1234);

julia> shuffle(mt1, 1:10, randshuffle) == Random.shuffle(mt2, 1:10)
true

```
"""
struct RandomShuffle <: AbstractRandomShuffle end

"""
    randshuffle

The singleton instance of type [`RandomShuffle`](@ref)
"""
const randshuffle = RandomShuffle()

shuffle!(r::AbstractRNG, c::AbstractArray, s::RandomShuffle) = Random.shuffle!(r, c)

## GilbertShannonReeds ##

"""
    GilbertShannonReeds

type with no fields representing the [Gilbert-Shannon-Reeds](https://en.wikipedia.org/wiki/Gilbert–Shannon–Reeds_model)
model of card shuffling. See singleton instance [`gsrshuffle`](@ref).

An in-place [`shuffle!`](@ref) is not implemented for this algorithm. However, an in-place
[`nshuffle!`](@ref) is implemented.

# Examples
```jldoctest
julia> mt = MersenneTwister(1234);

julia> shuffle(mt, 1:7, gsrshuffle)
7-element Vector{Int64}:
 5
 6
 1
 2
 7
 3
 4

```
"""
struct GilbertShannonReeds <: AbstractRandomShuffle end

"""
    gsrshuffle

The singleton instance of type [`GilbertShannonReeds`](@ref).
"""
const gsrshuffle = GilbertShannonReeds()

function shuffle(
    r::AbstractRNG,
    c::AbstractArray,
    s::GilbertShannonReeds,
    out::AbstractArray = similar(c),
)
    length(out) == length(c) || throw(ArgumentError("array lengths c and out must equal"))

    # flip a coin to determine from which pile each item will come
    flips = rand(r, Bool, length(c))

    # positions in the collection for the first pile and second pile
    pos1 = 0
    pos2 = count(flips)

    # Get items from respective pile
    for (i, frmfirst) in enumerate(flips)
        @inbounds out[i] = c[frmfirst ? pos1 += 1 : pos2 += 1]
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
