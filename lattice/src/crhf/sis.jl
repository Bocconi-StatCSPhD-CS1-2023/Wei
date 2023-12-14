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