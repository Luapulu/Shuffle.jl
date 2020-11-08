# Reference

```@contents
Pages = ["reference.md"]
Depth = 3
```

## Basic Functions

```@docs
shuffle
shuffle!
nshuffle
nshuffle!
```

## Shuffling Algorithms

```@docs
AbstractShuffle
```

### Deterministic Shuffles

```@docs
AbstractDeterministicShuffle
Faro
infaro
outfaro
inweave
outweave
Cut
```

### Random Shuffles

```@docs
AbstractRandomShuffle
RandomShuffle
randshuffle
GilbertShannonReeds
gsrshuffle
```

## Defaults

```@docs
Shuffle.DEFAULTS
```
