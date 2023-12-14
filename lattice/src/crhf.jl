struct HashContextSIS
    q::Int
    n::Int
    m::Int
    A::Matrix
    HashContextSIS(q, n, m) = isprime(q) && n > 0 && m > 0 ? new(q, n, m, Random.rand(1:q, (n, m))) : error("Invalid paramters!") 
end

function crhfSIS(z, ctx::HashContextSIS)
    return map((x) -> x % ctx.q, ctx.A * z)
end

struct HashContextRingSIS
    q::Int
    n::Int
    m::Int
    a::Array{Any}
    R_q::Ring  
end

function HashContextRingSIS(q, n, m)
    if !(isprime(q) && n > 0 && m > 0)
        error("Invalid paramters!")
    end
    Z_q = GF(q)
    R_q, x = polynomial_ring(Z_q, "x")
    R_n = residue_ring(R_q, x^n + 1)
    a = Array{Any}(nothing, m)
    for i = 1:m
        a[i] = rand(R_n, n-1:n-1)
    end
    return HashContextRingSIS(q, n, m, a, R_q)
end

function crhfRingSIS(z, ctx::HashContextRingSIS)
    r = zero(ctx.R_q)
    for i = 1:ctx.m
        r = r + z * ctx.a[i]
    end
    return r
end

function getRandomPrime(l)
    return Random.rand(primes(2^l, 2^(l+1)))
end