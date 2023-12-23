struct HashContextSIS
    q::Int
    n::Int
    m::Int
    A::Matrix
end

function HashContextSIS(q, n, m)
    A = Random.rand(1:q, (n, m))
    return HashContextSIS(q, n, m, A)
end

function crhfSIS(z, ctx::HashContextSIS)
    return map((x) -> x % ctx.q, ctx.A * z)
end