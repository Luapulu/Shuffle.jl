var documenterSearchIndex = {"docs":
[{"location":"reference/#Reference","page":"API Reference","title":"Reference","text":"","category":"section"},{"location":"reference/","page":"API Reference","title":"API Reference","text":"Pages = [\"reference.md\"]\nDepth = 3","category":"page"},{"location":"reference/#Basic-Functions","page":"API Reference","title":"Basic Functions","text":"","category":"section"},{"location":"reference/","page":"API Reference","title":"API Reference","text":"shuffle\nshuffle!\nnshuffle\nnshuffle!","category":"page"},{"location":"reference/#Shuffle.shuffle","page":"API Reference","title":"Shuffle.shuffle","text":"shuffle([rng=GLOBAL_RNG,], c, s::AbstractShuffle=RandomShuffle())\n\nshuffle collection c using shuffling algorithm s. To shuffle c in-place, see shuffle!. A random-number generator rng may be supplied for random shuffling algorithms.\n\nExamples\n\njulia> mt = MersenneTwister(1234);\n\njulia> shuffle(mt, [1, 2, 3, 4, 5, 6, 7, 8], GilbertShannonReeds())\n8-element Array{Int64,1}:\n 6\n 7\n 1\n 2\n 8\n 3\n 4\n 5\n\njulia> shuffle([6, 5, 4, 3, 2, 1], Faro(:in))\n6-element Array{Int64,1}:\n 3\n 6\n 2\n 5\n 1\n 4\n\n\n\n\n\n","category":"function"},{"location":"reference/#Shuffle.shuffle!","page":"API Reference","title":"Shuffle.shuffle!","text":"shuffle!([rng=GLOBAL_RNG,], c, s::AbstractShuffle=RandomShuffle())\n\nshuffle collection c in-place using shuffling algorithm s. A random-number generator rng may be supplied for random shuffling algorithms.\n\nExamples\n\njulia> mt = MersenneTwister(1234);\n\njulia> a = collect(1:6);\n\njulia> shuffle!(mt, a); a\n6-element Array{Int64,1}:\n 2\n 1\n 3\n 6\n 4\n 5\n\njulia> shuffle!(a, Faro(:out)); a\n6-element Array{Int64,1}:\n 2\n 6\n 1\n 4\n 3\n 5\n\n\n\n\n\n","category":"function"},{"location":"reference/#Shuffle.nshuffle","page":"API Reference","title":"Shuffle.nshuffle","text":"nshuffle([rng=GLOBAL_RNG,], c, n::Integer, s::AbstractShuffle=RandomShuffle())\n\nshuffle collection c n times using shuffling algorithm s. A random-number generator rng may be supplied for random shuffling algorithms. To shuffle c in-place see nshuffle!\n\nExamples\n\njulia> nshuffle(collect(1:8), 3, Faro(:in))\n8-element Array{Int64,1}:\n 8\n 7\n 6\n 5\n 4\n 3\n 2\n 1\n\n\n\n\n\n","category":"function"},{"location":"reference/#Shuffle.nshuffle!","page":"API Reference","title":"Shuffle.nshuffle!","text":"nshuffle!([rng=GLOBAL_RNG,], c, n::Integer, s::AbstractShuffle=RandomShuffle())\n\nshuffle collection c in-place n times using shuffling algorithm s. A random-number generator rng may be supplied for random shuffling algorithms.\n\nExamples\n\njulia> mt = MersenneTwister(1234);\n\njulia> a = collect(1:7);\n\njulia> nshuffle!(mt, a, 3, GilbertShannonReeds()); a\n7-element Array{Int64,1}:\n 5\n 6\n 1\n 7\n 2\n 3\n 4\n\n\n\n\n\n","category":"function"},{"location":"reference/#Shuffling-Algorithms","page":"API Reference","title":"Shuffling Algorithms","text":"","category":"section"},{"location":"reference/","page":"API Reference","title":"API Reference","text":"AbstractShuffle","category":"page"},{"location":"reference/#Shuffle.AbstractShuffle","page":"API Reference","title":"Shuffle.AbstractShuffle","text":"AbstractShuffle\n\nSupertype for AbstractDeterministicShuffle and AbstractRandomShuffle.\n\nImplementation\n\nNew shuffling algorithm types should be sub types of either AbstractDeterministicShuffle or AbstractRandomShuffle. If an algorithm can be defined in-place, only shuffle! needs to be extended. shuffle, nshuffle and nshuffle! will make a copy / repeatedly call shuffle! as needed. If the algorithm can not be defined in-place, define shuffle and nshuffle!. nshuffle will make a copy and call nshuffle!.\n\n\n\n\n\n","category":"type"},{"location":"reference/#Deterministic-Shuffles","page":"API Reference","title":"Deterministic Shuffles","text":"","category":"section"},{"location":"reference/","page":"API Reference","title":"API Reference","text":"AbstractDeterministicShuffle\nFaro","category":"page"},{"location":"reference/#Shuffle.AbstractDeterministicShuffle","page":"API Reference","title":"Shuffle.AbstractDeterministicShuffle","text":"AbstractDeterministicShuffle <: AbstractShuffle\n\nSupertype for fully deterministic shuffle algorithms such as Faro\n\nImplementation\n\nNew deterministic shuffling algorithms should implement either shuffle or shuffle!, as appropriate. The new shuffle method should take a collection to be shuffled as the first argument and an instance of the new shuffling algorithm type as the second argument.\n\nFor example:\n\nstruct MyShuffle <: AbstractDeterministicShuffle\n    parameter\nend\n\nfunction shuffle(c::AbstractArray, s::MyShuffle, prealloc_out=similar(c))\n    # Do the shuffling\n\n    return prealloc_out\nend\n\nPre-allocating the output makes it easy to also write an efficient nshuffle! function for algorithms that cannot be written in-place.\n\nSee also: AbstractShuffle\n\n\n\n\n\n","category":"type"},{"location":"reference/#Shuffle.Faro","page":"API Reference","title":"Shuffle.Faro","text":"Faro(s::Symbol)\nWeave(s::Symbol)\n\nFaro (weave) shuffling algorithm where s can be :in for an in-shuffle or :out for an out-shuffle.\n\nExamples\n\njulia> shuffle([1, 2, 3, 4, 5, 6, 7, 8], Faro(:out))\n8-element Array{Int64,1}:\n 1\n 5\n 2\n 6\n 3\n 7\n 4\n 8\n\njulia> nshuffle(collect(1:52), 26, Weave(:in)) == collect(52:-1:1)\ntrue\n\n\n\n\n\n","category":"type"},{"location":"reference/#Random-Shuffles","page":"API Reference","title":"Random Shuffles","text":"","category":"section"},{"location":"reference/","page":"API Reference","title":"API Reference","text":"AbstractRandomShuffle\nRandomShuffle\nGilbertShannonReeds","category":"page"},{"location":"reference/#Shuffle.AbstractRandomShuffle","page":"API Reference","title":"Shuffle.AbstractRandomShuffle","text":"AbstractRandomShuffle <: AbstractShuffle\n\nSupertype for partly or fully random shuffle algorithms such as RandomShuffle and GilbertShannonReeds.\n\nImplementation\n\nNew random shuffling algorithms should implement either shuffle or shuffle!, as appropriate. The new shuffle method should take a Random.AbstractRNG as the first argument, a collection to be shuffled as the second argument and an instance of the new shuffling algorithm type as the third argument.\n\nFor example:\n\nstruct MyShuffle <: AbstractRandomShuffle end\n\nfunction shuffle!(r::AbstractRNG, c, s::MyShuffle)\n    # Do the shuffling, passing r to any random number generating functions\n\n    return c\nend\n\nSee also: AbstractShuffle\n\n\n\n\n\n","category":"type"},{"location":"reference/#Shuffle.RandomShuffle","page":"API Reference","title":"Shuffle.RandomShuffle","text":"RandomShuffle()\n\ncompletely randomise order of given collection.\n\nThis algorithm is set as the default. See DEFAULTS.\n\nExamples\n\njulia> mt = MersenneTwister(1234);\n\njulia> shuffle(mt, 1:7)\n7-element Array{Int64,1}:\n 1\n 2\n 3\n 7\n 6\n 4\n 5\n\n\n\n\n\n\n","category":"type"},{"location":"reference/#Shuffle.GilbertShannonReeds","page":"API Reference","title":"Shuffle.GilbertShannonReeds","text":"GilbertShannonReeds()\n\nGilbert-Shannon-Reeds model of card shuffling.\n\nAn in-place shuffle! is not implemented for this algorithm. However, nshuffle! is implemented.\n\nExamples\n\njulia> mt = MersenneTwister(1234);\n\njulia> shuffle(mt, 1:7, GilbertShannonReeds())\n7-element Array{Int64,1}:\n 5\n 6\n 1\n 2\n 7\n 3\n 4\n\n\n\n\n\n\n","category":"type"},{"location":"reference/#Defaults","page":"API Reference","title":"Defaults","text":"","category":"section"},{"location":"reference/","page":"API Reference","title":"API Reference","text":"Shuffle.DEFAULTS","category":"page"},{"location":"reference/#Shuffle.DEFAULTS","page":"API Reference","title":"Shuffle.DEFAULTS","text":"DEFAULTS\n\nbinding to a mutable struct containing the default shuffling algorithm. RandomShuffle is set initially.\n\nExamples\n\njulia> Shuffle.DEFAULTS\nShuffle.Defaults(RandomShuffle())\n\njulia> mt1 = MersenneTwister(1234); mt2 = MersenneTwister(1234);\n\njulia> shuffle(mt1, collect(1:100)) == shuffle(mt2, collect(1:100), RandomShuffle())\ntrue\n\njulia> Shuffle.DEFAULTS.shuffle = Faro(:in); Shuffle.DEFAULTS\nShuffle.Defaults(Faro(:in))\n\njulia> shuffle([1, 2, 3, 4, 5, 6, 7, 8])\n8-element Array{Int64,1}:\n 5\n 1\n 6\n 2\n 7\n 3\n 8\n 4\n\njulia> Shuffle.DEFAULTS.shuffle = RandomShuffle();\n\n\n\n\n\n","category":"constant"},{"location":"#Shuffle.jl","page":"Home","title":"Shuffle.jl","text":"","category":"section"},{"location":"#Module-Overview","page":"Home","title":"Module Overview","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Shuffle","category":"page"},{"location":"#Shuffle","page":"Home","title":"Shuffle","text":"Shuffle\n\nSupport for a number of deterministic and random shuffling algorithms. Provides functions shuffle, shuffle!, nshuffle and nshuffle! as well as the following shuffling algorithms:\n\nfaro (or weave) shuffle,\nrandom shuffle (uses Random.shuffle) and\nGilbert-Shannon-Reeds model.\n\n\n\n\n\n","category":"module"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The package isn't registered at the moment. Install in the REPL using:","category":"page"},{"location":"","page":"Home","title":"Home","text":"]add https://github.com/Luapulu/Shuffle.jl.git","category":"page"},{"location":"#Basic-Usage","page":"Home","title":"Basic Usage","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"DocTestSetup = quote\n    using Shuffle\n    import Random\n    using Random: MersenneTwister\nend","category":"page"},{"location":"","page":"Home","title":"Home","text":"Shuffle.shuffle works just like Random.shuffle by default.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using Shuffle\n\njulia> shuffle([1, 2, 3, 4, 5, 6, 7])\n7-element Array{Int64,1}:\n 5\n 1\n 4\n 6\n 2\n 3\n 7","category":"page"},{"location":"","page":"Home","title":"Home","text":"The default shuffling algorithm randomises a collection totally, but you can just as easily use any other algorithm. See Shuffle.DEFAULTS to set another algorithm as the default.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> shuffle(collect(1:52), GilbertShannonReeds())\n52-element Array{Int64,1}:\n 30\n  1\n 31\n 32\n 33\n  2\n  3\n  4\n  5\n 34\n  ⋮\n 49\n 50\n 51\n 25\n 26\n 27\n 52\n 28\n 29","category":"page"},{"location":"","page":"Home","title":"Home","text":"In-place shuffling works, too.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> arr = [\"A\", \"B\", \"C\", \"D\"];\n\njulia> shuffle!(arr, Faro(:in));\n\njulia> arr\n4-element Array{String,1}:\n \"C\"\n \"A\"\n \"D\"\n \"B\"","category":"page"},{"location":"","page":"Home","title":"Home","text":"We can also shuffle 3 times in a row (and get back to the original order).","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> nshuffle!(arr, 3, Faro(:in))\n4-element Array{String,1}:\n \"A\"\n \"B\"\n \"C\"\n \"D\"","category":"page"}]
}
