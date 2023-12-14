using Random
using Primes
using Distributions

struct ContextLWE
    q::Int
    n::Int
    m::Int
    A::Matrix
    w::Number
    ContextLWE(q, n, m) = isprime(q) && n > 0 && m > 0 ? new(q, n, m, Random.rand(1:q, (m, n)), (Random.rand(1:100)*q/100)) : error("Invalid paramters!") 
end

function discreteGaussian(w::Number)
    return Int(round(Random.rand(Normal(0, w), 1)[1]))
end

function encrypt(z, ctx::ContextLWE)
    return map((x) -> (x + discreteGaussian(ctx.w)) % ctx.q, ctx.A * z)
end

ctx = ContextLWE(5, 5, 5)
z = Random.rand(1:ctx.q, ctx.n)
encrypt(z, ctx)