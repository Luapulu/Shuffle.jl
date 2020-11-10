@testset "Defaults" begin
    @test Shuffle.DEFAULTS.shuffle === RandomShuffle()

    let mt1 = MersenneTwister(1234), mt2 = MersenneTwister(1234), x = rand(1000)
        @test shuffle(mt1, x) == shuffle(mt2, x, RandomShuffle())
    end

    let mt1 = MersenneTwister(123), mt2 = MersenneTwister(123), x = rand(1000)
        @test shuffle!(mt1, x) == shuffle!(mt2, x, RandomShuffle())
    end

    let mt1 = MersenneTwister(12), mt2 = MersenneTwister(12), x = rand(1000)
        @test nshuffle(mt1, x, 5) == nshuffle(mt2, x, 5, RandomShuffle())
    end

    let mt1 = MersenneTwister(1), mt2 = MersenneTwister(1), x = rand(1000)
        @test nshuffle!(mt1, x, 5) == nshuffle!(mt2, x, 5, RandomShuffle())
    end

    Shuffle.DEFAULTS.shuffle = Faro{:in}()
    @test Shuffle.DEFAULTS.shuffle === Faro{:in}()

    @test shuffle(collect(1:100)) == shuffle(collect(1:100), Faro{:in}())

    @test shuffle!(collect(1:100)) == shuffle!(collect(1:100), Faro{:in}())

    @test nshuffle(collect(1:100), 5) == nshuffle(collect(1:100), 5, Faro{:in}())

    @test nshuffle!(collect(1:100), 5) == nshuffle!(collect(1:100), 5, Faro{:in}())

    Shuffle.DEFAULTS.shuffle = RandomShuffle()
    @test Shuffle.DEFAULTS.shuffle === RandomShuffle()
end

@testset "Default RNG" begin
    rng = copy(default_rng())
    @test shuffle(collect(1:100), RandomShuffle()) ==
          shuffle(rng, collect(1:100), RandomShuffle())

    rng = copy(default_rng())
    @test shuffle!(collect(1:100), RandomShuffle()) ==
          shuffle!(rng, collect(1:100), RandomShuffle())

    rng = copy(default_rng())
    @test nshuffle(collect(1:100), 5, RandomShuffle()) ==
          nshuffle(rng, collect(1:100), 5, RandomShuffle())

    rng = copy(default_rng())
    @test nshuffle!(collect(1:100), 6, RandomShuffle()) ==
          nshuffle!(rng, collect(1:100), 6, RandomShuffle())
end
