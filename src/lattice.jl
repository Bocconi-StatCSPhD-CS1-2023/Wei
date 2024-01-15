module lattice

using Random
using Primes
using LinearAlgebra

export HashContextSIS, crhfSIS
export HashContextRingSIS, crhfRingSIS
export PolyRing, mult, NTT_mult_nega
export getRandomPrime
export SHA3_224, SHA3_256, SHA3_384, SHA3_512, SHAKE128, SHAKE256
export Bits_2_Bytes, Bytes_2_Bits

include("crhf/ringsis.jl")
include("crhf/sis.jl")

include("sha3/sha3.jl")

include("utils.jl")
end