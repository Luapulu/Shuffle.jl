# Shuffle.jl

## Module Overview

```@docs
Shuffle
```

## Installation

The package isn't registered at the moment. Install in the REPL using:

```julia
]add https://github.com/Luapulu/Shuffle.jl.git
```

## Basic Usage

```@meta
DocTestSetup = quote
    using Shuffle
    import Random
    using Random: MersenneTwister
end
```

[`Shuffle.shuffle`](https://luapulu.github.io/Shuffle.jl/stable/reference/#Shuffle.shuffle) works just like [`Random.shuffle`](https://docs.julialang.org/en/v1/stdlib/Random/#Random.shuffle) by default.

```jldoctest; setup = :(Random.seed!(1))
julia> using Shuffle

julia> shuffle([1, 2, 3, 4, 5, 6, 7])
7-element Array{Int64,1}:
 5
 1
 4
 6
 2
 3
 7
```

In fact, they behave identically.

```jldoctest
julia> mt1 = MersenneTwister(1234); mt2 = MersenneTwister(1234);

julia> Shuffle.shuffle(mt1, collect(1:100)) == Random.shuffle(mt2, collect(1:100))
true
```

The default algorithm is [Fisher-Yates](https://luapulu.github.io/Shuffle.jl/stable/reference/#Shuffle.FisherYates), as implemented by [Random](https://docs.julialang.org/en/v1/stdlib/Random/), but you can just as easily use any other algorithm. See [`Shuffle.DEFAULTS`](@ref) to set another algorithm as the default.

```jldoctest; setup = :(Random.seed!(1))
julia> shuffle(collect(1:52), GilbertShannonReeds())
52-element Array{Int64,1}:
 30
  1
 31
 32
 33
  2
  3
  4
  5
 34
  ⋮
 49
 50
 51
 25
 26
 27
 52
 28
 29
```

In-place shuffling works, too.

```jldoctest faro
julia> arr = ["A", "B", "C", "D"];

julia> shuffle!(arr, Faro(:in));

julia> arr
4-element Array{String,1}:
 "C"
 "A"
 "D"
 "B"
```

We can shuffle 3 more times to get back to the original order.

```jldoctest faro
julia> nshuffle!(arr, 3, Faro(:in))
4-element Array{String,1}:
 "A"
 "B"
 "C"
 "D"
```
