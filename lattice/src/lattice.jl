module lattice

using Random
using Primes
using LinearAlgebra
using AbstractAlgebra

export HashContextSIS, crhfSIS
export HashContextRingSIS, crhfRingSIS
export getRandomPrime

include("crhf.jl")
include("utils.jl")
end