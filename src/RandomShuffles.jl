## RandomShuffle ##

"""
    RandomShuffle()

completely randomise order of given collection.

This algorithm is set as the default. See [`DEFAULTS`](@ref).

# Examples
```jldoctest
julia> mt = MersenneTwister(1234);

julia> shuffle(mt, 1:7)
7-element Array{Int64,1}:
 1
 2
 3
 7
 6
 4
 5

```
"""
struct RandomShuffle <: AbstractRandomShuffle end

shuffle!(r::AbstractRNG, c::AbstractArray, s::RandomShuffle) = Random.shuffle!(r, c)

## GilbertShannonReeds ##

"""
    GilbertShannonReeds()

[Gilbert-Shannon-Reeds](https://en.wikipedia.org/wiki/Gilbert–Shannon–Reeds_model)
model of card shuffling.

An in-place [`shuffle!`](@ref) is not implemented for this algorithm. However,
[`nshuffle!`](@ref) is implemented.

# Examples
```jldoctest
julia> mt = MersenneTwister(1234);

julia> shuffle(mt, 1:7, GilbertShannonReeds())
7-element Array{Int64,1}:
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

function shuffle(
    r::AbstractRNG,
    c::AbstractArray,
    s::GilbertShannonReeds,
    out::AbstractArray = similar(c),
)
    length(out) == length(c) || throw(ArgumentError("array lengths c and out must equal"))

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
