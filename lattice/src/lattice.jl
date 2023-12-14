module lattice

using Random
using Primes
using LinearAlgebra
using AbstractAlgebra

export HashContextSIS, crhfSIS
export HashContextRingSIS, crhfRingSIS
export getRandomPrime

include("crhf/ringsis.jl")
include("crhf/sis.jl")

include("utils.jl")
end