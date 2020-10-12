## FisherYates ##

"""
    FisherYates()

Fisher-Yates shuffling algorithm as implemented by standard library module Random.
"""
struct FisherYates <: RandomShuffle end

shuffle!(r::AbstractRNG, c::AbstractArray, s::FisherYates) = Random.shuffle!(r, c)

## GilbertShannonReeds ##

"""
    GilbertShannonReeds()

Gilbert-Shannon-Reeds shuffling algorithm.
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
