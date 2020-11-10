## Faro ##

"""
    Faro{S}
    Weave{S}

Type with no fields representing the [Faro (weave)](https://en.wikipedia.org/wiki/Faro_shuffle)
card shuffle where `S` can be `:in` for an in-shuffle or `:out` for an out-shuffle.

See singleton instances [`infaro`](@ref), [`outfaro`](@ref), [`inweave`](@ref),
[`outweave`](@ref).

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

julia> nshuffle(collect(1:52), 26, inweave) == collect(52:-1:1)
true
```
"""
struct Faro{S} <: AbstractDeterministicShuffle end

const Weave{S} = Faro{S}

"""
    infaro

The singleton instance of type [`Faro{:in}`](@ref)
"""
const infaro = Faro{:in}()

"""
    outfaro

The singleton instance of type [`Faro{:out}`](@ref)
"""
const outfaro = Faro{:out}()

"""
    inweave

Alias for [`infaro`](@ref).
"""
const inweave = Weave{:in}()

"""
    outweave

Alias for [`outfaro`](@ref).
"""
const outweave = Weave{:out}()

@inline _bo(::Array, i::Int, ::Faro{:in}) = 2i
@inline _bo(::Array, i::Int, ::Faro{:out}) = 2i - 1
@inline _bo(c::AbstractArray, i::Int, ::Faro{:in}) = 2i + firstindex(c) - 1
@inline _bo(c::AbstractArray, i::Int, ::Faro{:out}) = 2i + firstindex(c) - 2

@inline _eo(::Array, i::Int, ::Faro{:in}) = 2i - 1
@inline _eo(::Array, i::Int, ::Faro{:out}) = 2i
@inline _eo(c::AbstractArray, i::Int, ::Faro{:in}) = 2i + firstindex(c) - 2
@inline _eo(c::AbstractArray, i::Int, ::Faro{:out}) = 2i + firstindex(c) - 1

function shuffle!(c::AbstractArray, f::Faro)
    iseven(length(c)) || error("Faro (Weave) shuffling requires even length array")

    hlf = length(c) ÷ 2 + firstindex(c) - 1

    tmp::Array = c[firstindex(c):hlf]

    for i in 1:length(c) ÷ 2
        @inbounds begin
            c[_eo(c, i, f)] = c[hlf + i]
            c[_bo(c, i, f)] = tmp[i]
        end
    end

    return c
end

## Cut ##

"""
    Cut(n::Integer)

represents a [cut](https://en.wikipedia.org/wiki/Cut_(cards)) at `n`, meaning elements up to
and including `n` are moved to the bottom or end of a collection, while the rest shift up to
the beginning.

No in-place [`shuffle!`](@ref) or [`nshuffle!`](@ref) exist for this shuffling type.

# Examples

```jldoctest
julia> shuffle([1, 2, 3, 4, 5, 6, 7], Cut(3))
7-element Array{Int64,1}:
 4
 5
 6
 7
 1
 2
 3
```
"""
struct Cut <: AbstractDeterministicShuffle
    n::Int
end

@inline _cuterr(A, n) = DomainError(
    n, "cannot cut array with indices $(eachindex(A)) at $n")
@inline _validcut(A, n) = firstindex(A) - 1 <= n <= lastindex(A)
@inline _checkcut(A, n) = _validcut(A, n) || throw(_cuterr(A, n))

shuffle(A::AbstractArray, c::Cut) = (_checkcut(A, c.n); circshift(A, -c.n))

nshuffle(A::AbstractArray, n::Integer, c::Cut) = (_checkcut(A, c.n); circshift(A, -c.n * n))
