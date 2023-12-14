struct HashContextSIS
    q::Int
    n::Int
    m::Int
    A::Matrix
end

function HashContextSIS(q, n, m)
    if !(isprime(q) && n > 0 && m > 0)
        error("Invalid paramters!")
    end
    A = Random.rand(1:q, (n, m))
    return HashContextSIS(q, n, m, A)
end

function crhfSIS(z, ctx::HashContextSIS)
    return map((x) -> x % ctx.q, ctx.A * z)
end