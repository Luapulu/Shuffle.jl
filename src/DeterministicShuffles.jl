"""
    Faro(s::Symbol)
    Weave(s::Symbol)

Faro (Weave) shuffling algorithm where `s` can be `:in` for an in-shuffle or `:out`
for an out-shuffle.
"""
struct Faro <: DeterministicShuffle
    in::Bool
end

const Weave = Faro

function Faro(s::Symbol)
    if s == :in
        return Faro(true)
    elseif s == :out
        return Faro(false)
    else
        error("Faro (Weave) can be :in or :out, not :$s")
    end
end

function shuffle!(c::AbstractArray, s::Faro, tmp = similar(c, (length(c) ÷ 2,)))
    iseven(length(c)) || error("Faro (Weave) shuffling requires even length array")
    2 * length(tmp) >= length(c) || error("temp array must be >= half chip array length")

    hlf = length(c) ÷ 2

    for i = 1:hlf
        @inbounds tmp[i] = c[i]
    end

    for i = 1:hlf
        @inbounds c[2i-s.in] = c[hlf+i]
        @inbounds c[2i-!s.in] = tmp[i]
    end

    return c
end
