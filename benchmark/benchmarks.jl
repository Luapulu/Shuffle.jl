using BenchmarkTools, Shuffle

const SUITE = BenchmarkGroup()

const DECK = collect(1:52)

## Faro ##

SUITE["Faro"] = BenchmarkGroup(["deterministic"])
SUITE["Faro"]["in"] = BenchmarkGroup()
SUITE["Faro"]["out"] = BenchmarkGroup()

SUITE["Faro"]["in"]["shuffle"] = @benchmarkable shuffle($DECK, Faro{:in}())

SUITE["Faro"]["in"]["shuffle!"] = @benchmarkable shuffle!($DECK, Faro{:in}())

SUITE["Faro"]["in"]["nshuffle"] = @benchmarkable nshuffle($DECK, 26, Faro{:in}())

SUITE["Faro"]["in"]["nshuffle!"] = @benchmarkable nshuffle!($DECK, 26, Faro{:in}())

SUITE["Faro"]["out"]["shuffle"] = @benchmarkable shuffle($DECK, Faro{:out}())

SUITE["Faro"]["out"]["shuffle!"] = @benchmarkable shuffle!($DECK, Faro{:out}())

SUITE["Faro"]["out"]["nshuffle"] = @benchmarkable nshuffle($DECK, 26, Faro{:out}())

SUITE["Faro"]["out"]["nshuffle!"] = @benchmarkable nshuffle!($DECK, 26, Faro{:out}())

## Cut ##

SUITE["Cut"] = BenchmarkGroup(["deterministic"])

SUITE["Cut"]["shuffle"] = @benchmarkable shuffle($DECK, Cut(n)) setup=(n=rand(0:52))

SUITE["Cut"]["nshuffle"] = @benchmarkable nshuffle($DECK, 10, Cut(n)) setup=(n=rand(0:52))

## RandomShuffle ##

SUITE["Random"] = BenchmarkGroup(["random"])

SUITE["Random"]["shuffle"] = @benchmarkable shuffle($DECK, RandomShuffle())

SUITE["Random"]["shuffle!"] = @benchmarkable shuffle!($DECK, RandomShuffle())

## GilbertShannonReeds ##

SUITE["GilbertShannonReeds"] = BenchmarkGroup(["random"])

SUITE["GilbertShannonReeds"]["shuffle"] =
    @benchmarkable shuffle($DECK, GilbertShannonReeds())

SUITE["GilbertShannonReeds"]["nshuffle"] =
    @benchmarkable nshuffle($DECK, 7, GilbertShannonReeds())

SUITE["GilbertShannonReeds"]["nshuffle!"] =
    @benchmarkable nshuffle!($DECK, 7, GilbertShannonReeds())
