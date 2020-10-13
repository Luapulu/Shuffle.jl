using Test, Shuffle
using Random: rand, MersenneTwister
import Random

@testset "Faro" begin
    @test shuffle!([1, 0], Faro(:in)) == [0, 1]
    @test shuffle([1, 0], Faro(:out)) == [1, 0]

    @test shuffle([1, 2, 3, 4], Faro(:in)) == [3, 1, 4, 2]
    @test shuffle!([1, 2, 3, 4], Faro(:out)) == [1, 3, 2, 4]

    shuffle!([1, 2, 3, 4, 5, 6], Faro(:in)) == [4, 1, 5, 2, 6, 3]
    shuffle([1, 2, 3, 4, 5, 6], Faro(:out)) == [1, 4, 2, 5, 3, 6]

    arr = rand("ATCG", 1000)
    inshuffled = shuffle(arr, Faro(:in))
    outshuffled = shuffle(arr, Faro(:out))

    @test inshuffled[1:2:end] == arr[501:end]
    @test inshuffled[2:2:end] == arr[1:500]

    @test outshuffled[2:2:end] == arr[501:end]
    @test outshuffled[1:2:end] == arr[1:500]

    arr = nshuffle(collect(1:52), 26, Faro(:in))
    @test arr == collect(52:-1:1)

    nshuffle!(arr, 26, Faro(:in))
    @test arr == collect(1:52)

    @test nshuffle!(collect(1:52), 8, Faro(:out)) == collect(1:52)
end

@testset "FisherYates" begin
    let mt1 = MersenneTwister(42), mt2 = MersenneTwister(42)
        @test shuffle(mt1, collect(1:100)) == Random.shuffle(mt2, collect(1:100))
    end

    let mt1 = MersenneTwister(12), mt2 = MersenneTwister(12)
        @test shuffle!(mt1, collect(1:100)) == Random.shuffle!(mt2, collect(1:100))
    end

    let mt1 = MersenneTwister(12), mt2 = MersenneTwister(12)
        arr1 = Random.shuffle!(mt2, collect(1:100))
        Random.shuffle!(mt2, arr1)
        Random.shuffle!(mt2, arr1)

        arr2 = collect(1:100)
        nshuffle!(mt1, arr2, 3, FisherYates())
        @test arr2 == arr1
    end
end

@testset "GilbertShannonReeds" begin
    # probably not the same after shuffling
    @test shuffle(collect(1:1000), GilbertShannonReeds()) != collect(1:1000)
    @test nshuffle(collect(1:52), 10, GilbertShannonReeds()) != collect(1:52)

    let mt1 = MersenneTwister(32), mt2 = MersenneTwister(32)
        @test shuffle(mt1, collect(1:100), GilbertShannonReeds()) ==
              shuffle(mt2, collect(1:100), GilbertShannonReeds())
    end

    let mt1 = MersenneTwister(153), mt2 = MersenneTwister(153)
        @test nshuffle(mt1, collect(1:100), 7, GilbertShannonReeds()) ==
              nshuffle(mt2, collect(1:100), 7, GilbertShannonReeds())
    end
end
