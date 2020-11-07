using Test, Shuffle, Documenter
using Random: MersenneTwister

@testset "Shuffle.jl" begin

@testset "Faro" begin
    @test Faro === Weave

    x = [1, 2, 3, 4, 5, 6]
    shuffle!(x, Faro{:in}()) == x == [4, 1, 5, 2, 6, 3]

    y = [1, 2, 3, 4, 5, 6]
    shuffle([1, 2, 3, 4, 5, 6], Faro{:out}()) == [1, 4, 2, 5, 3, 6] != y

    arr = rand("ATCG", 1000)
    inshuffled = shuffle(arr, Faro{:in}())
    outshuffled = shuffle(arr, Faro{:out}())

    @test inshuffled[1:2:end] == arr[501:end]
    @test inshuffled[2:2:end] == arr[1:500]

    @test outshuffled[2:2:end] == arr[501:end]
    @test outshuffled[1:2:end] == arr[1:500]

    arr = nshuffle(collect(1:52), 26, Faro{:in}())
    @test arr == collect(52:-1:1)

    revarr = collect(52:-1:1)
    nshuffle!(revarr, 26, Faro{:in}())
    @test revarr == collect(1:52)

    @test nshuffle!(collect(1:52), 8, Faro{:out}()) == collect(1:52)
end

@testset "RandomShuffle" begin
    # probably not the same after shuffling
    arr = rand(1000)
    arr_copy = copy(arr)
    @test shuffle!(arr, RandomShuffle()) == arr != arr_copy

    narr = rand(1000)
    narr_copy = copy(narr)
    @test nshuffle!(narr, 5, RandomShuffle()) == narr != narr_copy

    let mt1 = MersenneTwister(42), mt2 = MersenneTwister(42), x = rand(1000)
        @test shuffle(mt1, x, RandomShuffle()) ==
              shuffle!(mt2, x, RandomShuffle())
    end

    let mt1 = MersenneTwister(12), mt2 = MersenneTwister(12), x = rand(1000)
        @test shuffle(mt1, x, RandomShuffle()) ==
              shuffle!(mt2, x, RandomShuffle())
    end

    let mt1 = MersenneTwister(12), mt2 = MersenneTwister(12),
            mt3 = MersenneTwister(12), x = rand(1000)

        y = shuffle(mt1, x, RandomShuffle())
        shuffle!(mt1, y, RandomShuffle())
        shuffle!(mt1, y, RandomShuffle())

        @test nshuffle(mt2, x, 3, RandomShuffle()) == y

        @test nshuffle!(mt3, x, 3, RandomShuffle()) == y
    end
end

@testset "GilbertShannonReeds" begin
    # probably not the same after shuffling
    arr = rand(1000)
    @test shuffle(arr, GilbertShannonReeds()) != arr

    narr = rand(1000)
    narr_copy = copy(narr)
    @test nshuffle!(narr, 10, GilbertShannonReeds()) == narr != narr_copy

    let mt1 = MersenneTwister(32), mt2 = MersenneTwister(32), x = rand(1000)
        @test shuffle(mt1, x, GilbertShannonReeds()) ==
              shuffle(mt2, x, GilbertShannonReeds())
    end

    let mt1 = MersenneTwister(153), mt2 = MersenneTwister(153), x = rand(1000)
        @test nshuffle(mt1, x, 7, GilbertShannonReeds()) ==
              nshuffle!(mt2, x, 7, GilbertShannonReeds())
    end
end

if false
    DocMeta.setdocmeta!(
        Shuffle,
        :DocTestSetup,
        quote
            using Shuffle
            import Random
            using Random: MersenneTwister
        end;
        recursive=true
    )

    doctest(Shuffle)
end

end
