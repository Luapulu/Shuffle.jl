"""
    Shuffle

Support for a number of deterministic and random shuffling algorithms. Provides shuffle, shuffle!,
nshuffle and nshuffle!

Currently implemented shuffle algorithms:
- Faro (or Weave),
- Fisher-Yates (from standard library module Random) and
- Gilbert-Shannon-Reeds.
"""
module Shuffle

import Random # used so Random.shuffle! can be seperated from shuffle!

using Random: AbstractRNG, default_rng
using Base: copymutable

import Random: shuffle, shuffle!

export AbstractShuffle, DeterministicShuffle, RandomShuffle
export Faro, FisherYates, GilbertShannonReeds
export shuffle, shuffle!, nshuffle, nshuffle!

## Abstract Types ##

"""
    AbstractShuffle

Supertype for [`DeterministicShuffle`](@ref) and [`RandomShuffle`](@ref).
"""
abstract type AbstractShuffle end

"""
    DeterministicShuffle

Supertype for fully deterministic shuffle algorithms such as [`Faro`](@ref)
"""
abstract type DeterministicShuffle <: AbstractShuffle end

"""
    RandomShuffle

Supertype for partly or fully random shuffle algorithms such as [`FisherYates`](@ref) and
[`GilbertShannonReeds`](@ref).
"""
abstract type RandomShuffle <: AbstractShuffle end

## Include files ##

include("DeterministicShuffles.jl")
include("RandomShuffles.jl")

## Defaults ##

mutable struct Defaults
    shuffle::AbstractShuffle
end

const DEFAULTS = Defaults(FisherYates())

## Shuffle! and shuffle ##

"""
    shuffle!([rng=GLOBAL_RNG,], c, s::AbstractShuffle=FisherYates())

shuffle collection `c` in-place using shuffling algorithm `s`. A random-number generator `rng` may
be supplied for random shuffling algorithms.

When used with the default shuffling algorithm, `Shuffle.shuffle!` is identical to `Random.shuffle!`.
The default algorithm instance can be changed by setting `Shuffle.DEFAULTS.shuffle`.
"""
function shuffle!(c, s::AbstractShuffle=DEFAULTS.shuffle) end
shuffle!(c, s::RandomShuffle) = shuffle!(default_rng(), c, s)

"""
    shuffle([rng=GLOBAL_RNG,], c, s::AbstractShuffle=FisherYates())

shuffle collection `c` using shuffling algorithm `s`. A random-number generator `rng` may be
supplied for random shuffling algorithms. To shuffle `c` in-place, see [`shuffle!`](@ref).

When used with the default shuffling algorithm, `Shuffle.shuffle` is identical to `Random.shuffle`.
The default algorithm instance can be changed by setting `Shuffle.DEFAULTS.shuffle`.
"""
shuffle(c, s::AbstractShuffle=DEFAULTS.shuffle) = shuffle!(copymutable(c), s)
shuffle(c, s::RandomShuffle) = shuffle(default_rng(), c, s)
shuffle(r::AbstractRNG, c, s::RandomShuffle=DEFAULTS.shuffle) = shuffle!(r, copymutable(c), s)

## nshuffle! and nshuffle ##

"""
    nshuffle!([rng=GLOBAL_RNG,], c, n::Integer, s::AbstractShuffle=FisherYates())

shuffle collection `c` in-place `n` times using shuffling algorithm `s`. A random-number generator
`rng` may be supplied for random shuffling algorithms.

The default algorithm instance can be changed by setting `Shuffle.DEFAULTS.shuffle`.
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
`rng` may be supplied for random shuffling algorithms. To shuffle `c` in-place see [`nshuffle!`](@ref)

The default algorithm instance can be changed by setting `Shuffle.DEFAULTS.shuffle`.
"""
nshuffle(c, n::Integer, s::AbstractShuffle=DEFAULTS.shuffle) = nshuffle!(copymutable(c), n, s)
nshuffle(c, n::Integer, s::RandomShuffle) = nshuffle(default_rng(), c, n, s)
nshuffle(r::AbstractRNG, c, n::Integer, s::RandomShuffle=DEFAULTS.shuffle) =
    nshuffle!(r, copymutable(c), n, s)

end # module
