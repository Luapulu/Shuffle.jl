"""
    Faro{S}()
    Weave{S}()

[Faro (weave)](https://en.wikipedia.org/wiki/Faro_shuffle) card shuffle where
`S` can be `:in` for an in-shuffle or `:out` for an out-shuffle.

# Examples
```jldoctest
julia> shuffle([1, 2, 3, 4, 5, 6, 7, 8], Faro{:out}())
8-element Array{Int64,1}:
 1
 5
 2
 6
 3
 7
 4
 8

julia> nshuffle(collect(1:52), 26, Weave{:in}()) == collect(52:-1:1)
true
```
"""
struct Faro{S} <: AbstractDeterministicShuffle end

const Weave{S} = Faro{S}

_bo(::Faro{:in}) = 0
_bo(::Faro{:out}) = 1

_eo(::Faro{:in}) = 1
_eo(::Faro{:out}) = 0

function shuffle!(c::AbstractArray, f::Faro, tmp = similar(c, (length(c) ÷ 2,)))
    iseven(length(c)) || error("Faro (Weave) shuffling requires even length array")
    2 * length(tmp) >= length(c) || error("temp array must be >= half chip array length")

    hlf = length(c) ÷ 2

    for i = 1:hlf
        @inbounds tmp[i] = c[i]
    end

    for i = 1:hlf
        @inbounds c[2i - _eo(f)] = c[hlf+i]
        @inbounds c[2i - _bo(f)] = tmp[i]
    end

    return c
end
