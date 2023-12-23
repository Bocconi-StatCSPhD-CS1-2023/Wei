module lattice

using Random
using Primes
using LinearAlgebra

export HashContextSIS, crhfSIS
export HashContextRingSIS, crhfRingSIS
export PolyRing, mult, NTT_mult_nega
export getRandomPrime

include("crhf/ringsis.jl")
include("crhf/sis.jl")

include("utils.jl")
end