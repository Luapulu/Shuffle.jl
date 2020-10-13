"""
    Shuffle

Support for a number of deterministic and random shuffling algorithms. Provides functions
[`shuffle`](@ref), [`shuffle!`](@ref), [`nshuffle`](@ref) and [`nshuffle!`](@ref)
as well as the following shuffling algorithms:
- [faro (or weave) shuffle](https://luapulu.github.io/Shuffle.jl/stable/#Shuffle.Faro),
- [Fisher-Yates shuffle](https://luapulu.github.io/Shuffle.jl/stable/#Shuffle.FisherYates)
    (uses [`Random.shuffle`](https://docs.julialang.org/en/v1/stdlib/Random/#Random.shuffle)) and
- [Gilbert-Shannon-Reeds model](https://luapulu.github.io/Shuffle.jl/stable/#Shuffle.GilbertShannonReeds).
"""
module Shuffle

import Base: show
import Random # used so Random.shuffle! can be seperated from shuffle!

using Random: AbstractRNG, default_rng
using Base: copymutable

export AbstractShuffle, DeterministicShuffle, RandomShuffle
export Faro, Weave, FisherYates, GilbertShannonReeds
export shuffle, shuffle!, nshuffle, nshuffle!

## Abstract Types ##

"""
    AbstractShuffle

Supertype for [`DeterministicShuffle`](@ref) and [`RandomShuffle`](@ref).

# Implementation

New shuffling algorithm types should be sub types of either [`DeterministicShuffle`](@ref) or
[`RandomShuffle`](@ref). If an algorithm can be defined in-place, only [`shuffle!`](@ref) needs
to be extended. [`shuffle`](@ref), [`nshuffle`](@ref) and [`nshuffle!`](@ref) will make a copy /
repeatedly call [`shuffle!`](@ref) as needed. If the algorithm can not be defined in-place, define
[`shuffle`](@ref) and [`nshuffle!`](@ref). [`nshuffle`](@ref) will make a copy and call
[`nshuffle!`](@ref).
"""
abstract type AbstractShuffle end

"""
    DeterministicShuffle

Supertype for fully deterministic shuffle algorithms such as [`Faro`](@ref)

# Implementation

New deterministic shuffling algorithms should implement either [`shuffle`](@ref) or
[`shuffle!`](@ref), as appropriate. The new shuffle method should take a collection to be shuffled
as the first argument and an instance of the new shuffling algorithm type as the second argument.

For example:
```julia
struct MyShuffle <: DeterministicShuffle
    parameter::Any
end

function shuffle(c::AbstractArray, s::MyShuffle, prealloc_out=similar(c))
    # Do the shuffling

    return prealloc_out
end
```

Pre-allocating the output makes it easy to also write an efficient [`nshuffle!`](@ref) function
for algorithms that cannot be written in-place.

See also: [`AbstractShuffle`](@ref)
"""
abstract type DeterministicShuffle <: AbstractShuffle end

"""
    RandomShuffle

Supertype for partly or fully random shuffle algorithms such as [`FisherYates`](@ref) and
[`GilbertShannonReeds`](@ref).

# Implementation

New random shuffling algorithms should implement either [`shuffle`](@ref) or [`shuffle!`](@ref),
as appropriate. The new shuffle method should take a [`Random.AbstractRNG`](https://docs.julialang.org/en/v1/stdlib/Random/#Random.AbstractRNG)
as the first argument, a collection to be shuffled as the second argument and an instance of the
new shuffling algorithm type as the third argument.

For example:
```julia
struct MyShuffle <: RandomShuffle end

function shuffle!(r::AbstractRNG, c, s::MyShuffle)
    # Do the shuffling, passing r to any random number generating functions

    return c
end
```

See also: [`AbstractShuffle`](@ref)
"""
abstract type RandomShuffle <: AbstractShuffle end

## Include files ##

include("DeterministicShuffles.jl")
include("RandomShuffles.jl")

## Defaults ##

mutable struct Defaults
    shuffle::AbstractShuffle
end

"""
    DEFAULTS

binding to a mutable struct containing the default shuffling algorithm.

[`FisherYates`](@ref), as implemented in [Random](https://docs.julialang.org/en/v1/stdlib/Random/),
is set initially, meaning that [`Shuffle.shuffle`](@ref) behaves identically to
[`Random.shuffle`](https://docs.julialang.org/en/v1/stdlib/Random/#Random.shuffle) by default.

# Examples
```jldoctest
julia> Shuffle.DEFAULTS
Shuffle.Defaults(FisherYates())

julia> mt1 = MersenneTwister(1234); mt2 = MersenneTwister(1234);

julia> Shuffle.shuffle(mt1, collect(1:100)) == Random.shuffle(mt2, collect(1:100))
true

julia> Shuffle.DEFAULTS.shuffle = Faro(:in); Shuffle.DEFAULTS
Shuffle.Defaults(Faro(:in))

julia> shuffle([1, 2, 3, 4, 5, 6, 7, 8])
8-element Array{Int64,1}:
 5
 1
 6
 2
 7
 3
 8
 4

julia> Shuffle.DEFAULTS.shuffle = FisherYates();
```
"""
const DEFAULTS = Defaults(FisherYates())

## Shuffle! and shuffle ##

"""
    shuffle!([rng=GLOBAL_RNG,], c, s::AbstractShuffle=FisherYates())

shuffle collection `c` in-place using shuffling algorithm `s`. A random-number generator `rng`
may be supplied for random shuffling algorithms.

# Examples
```jldoctest
julia> mt = MersenneTwister(1234);

julia> a = collect(1:6);

julia> shuffle!(mt, a); a
6-element Array{Int64,1}:
 2
 1
 3
 6
 4
 5

julia> shuffle!(a, Faro(:out)); a
6-element Array{Int64,1}:
 2
 6
 1
 4
 3
 5
```
"""
function shuffle!(c, s::AbstractShuffle=DEFAULTS.shuffle) end
shuffle!(r::AbstractRNG, c) = shuffle!(r, c, DEFAULTS.shuffle)
shuffle!(c, s::RandomShuffle) = shuffle!(default_rng(), c, s)

"""
    shuffle([rng=GLOBAL_RNG,], c, s::AbstractShuffle=FisherYates())

shuffle collection `c` using shuffling algorithm `s`. To shuffle `c` in-place,
see [`shuffle!`](@ref). A random-number generator `rng` may be supplied for random shuffling
algorithms.

# Examples
```jldoctest
julia> mt = MersenneTwister(1234);

julia> shuffle(mt, [1, 2, 3, 4, 5, 6, 7, 8], GilbertShannonReeds())
8-element Array{Int64,1}:
 6
 7
 1
 2
 8
 3
 4
 5

julia> shuffle([6, 5, 4, 3, 2, 1], Faro(:in))
6-element Array{Int64,1}:
 3
 6
 2
 5
 1
 4
```
"""
shuffle(c, s::AbstractShuffle=DEFAULTS.shuffle) = shuffle!(copymutable(c), s)
shuffle(c, s::RandomShuffle) = shuffle(default_rng(), c, s)
shuffle(r::AbstractRNG, c, s::RandomShuffle=DEFAULTS.shuffle) = shuffle!(r, copymutable(c), s)

## nshuffle! and nshuffle ##

"""
    nshuffle!([rng=GLOBAL_RNG,], c, n::Integer, s::AbstractShuffle=FisherYates())

shuffle collection `c` in-place `n` times using shuffling algorithm `s`. A random-number generator
`rng` may be supplied for random shuffling algorithms.

# Examples
```jldoctest
julia> mt = MersenneTwister(1234);

julia> a = collect(1:7);

julia> nshuffle!(mt, a, 3, GilbertShannonReeds()); a
7-element Array{Int64,1}:
 5
 6
 1
 7
 2
 3
 4
```
"""
nshuffle!(c, n::Integer) = nshuffle!(c, n, DEFAULTS.shuffle)

function nshuffle!(r::AbstractRNG, c, n::Integer, s::RandomShuffle=DEFAULTS.shuffle)
    for i in 1:n
        shuffle!(r, c, s)
    end
    return c
end

nshuffle!(c, n::Integer, s::RandomShuffle) = nshuffle!(default_rng(), c, n, s)

function nshuffle!(c, n::Integer, s::DeterministicShuffle)
    for i in 1:n
        shuffle!(c, s)
    end
    return c
end

"""
    nshuffle([rng=GLOBAL_RNG,], c, n::Integer, s::AbstractShuffle=FisherYates())

shuffle collection `c` `n` times using shuffling algorithm `s`. A random-number generator
`rng` may be supplied for random shuffling algorithms.
To shuffle `c` in-place see [`nshuffle!`](@ref)

# Examples
```jldoctest
julia> nshuffle(collect(1:8), 3, Faro(:in))
8-element Array{Int64,1}:
 8
 7
 6
 5
 4
 3
 2
 1
```
"""
nshuffle(c, n::Integer, s::AbstractShuffle=DEFAULTS.shuffle) = nshuffle!(copymutable(c), n, s)
nshuffle(c, n::Integer, s::RandomShuffle) = nshuffle(default_rng(), c, n, s)
nshuffle(r::AbstractRNG, c, n::Integer, s::RandomShuffle=DEFAULTS.shuffle) =
    nshuffle!(r, copymutable(c), n, s)

end # module
