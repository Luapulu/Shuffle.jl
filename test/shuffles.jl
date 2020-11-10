@testset "Faro" begin
    @test Faro === Weave

    @test infaro === inweave === Faro{:in}()
    @test outfaro === outweave === Faro{:out}()

    x = [1, 2, 3, 4, 5, 6]
    shuffle!(x, Faro{:in}()) == x == [4, 1, 5, 2, 6, 3]

    y = [1, 2, 3, 4, 5, 6]
    shuffle([1, 2, 3, 4, 5, 6], Faro{:out}()) == [1, 4, 2, 5, 3, 6] != y

    arr = rand(Int, 1000)
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

    @test nshuffle(collect(1:52), 8, Faro{:out}()) == collect(1:52)

    OA = OffsetArray(1:6, 6:11)
    @test parent(shuffle(OA, Faro{:out}())::OffsetArray) == [1, 4, 2, 5, 3, 6]
    @test parent(shuffle(OA, Faro{:in}())::OffsetArray) == [4, 1, 5, 2, 6, 3]
end

@testset "Cut" begin
    @test shuffle([1, 2, 3, 4, 5], Cut(2)) == [3, 4, 5, 1, 2]

    @test shuffle([1, 2, 3, 4, 5], Cut(0)) == [1, 2, 3, 4, 5]

    @test shuffle([1, 2, 3, 4, 5], Cut(5)) == [1, 2, 3, 4, 5]

    @test_throws DomainError shuffle([1, 2, 3, 4, 5], Cut(7))

    @test nshuffle(collect(1:100), 7, Cut(10)) == vcat(71:100, 1:70)
end

@testset "RandomShuffle" begin

    @test randshuffle === RandomShuffle()

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

    @test gsrshuffle === GilbertShannonReeds()

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
