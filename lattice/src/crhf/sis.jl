using Random
using Primes

struct HashContextSIS
    q::Int
    n::Int
    m::Int
    A::Matrix #<C> this is an abstract type; code such as crhfSIS won't be able to infer its type during compilation, hurting performance. If you want to keep it general, you can use a parametric type
end

function HashContextSIS(q::Int, n::Int, m::Int)
    if !isprime(q)
        error("q must be a prime!")
    end
    A = Random.rand(1:q, (n, m))
    return HashContextSIS(q, n, m, A)
end

function crhfSIS(z::Vector{Int}, ctx::HashContextSIS)
    return map((x) -> x % ctx.q, ctx.A * z)
end

#an example
#ctx = HashContextSIS(43, 14, 43) # initialize the context, note that q has to be a prime
#z = Random.rand(0:ctx.q-1, ctx.m) # randomly generate an input to the hash function
#crhfSIS(z, ctx) # compute the hash