struct HashContextRingSIS
    q::Int
    n::Int
    m::Int
    a::Array{Any}
    R::Ring
    R_q::Ring  
end

function HashContextRingSIS(q, n, m)
    if !(isprime(q) && n > 0 && m > 0)
        error("Invalid paramters!")
    end
    Z_q = GF(q)
    R, x = polynomial_ring(Z_q, "x")
    R_q = residue_ring(R, x^n + 1)
    a = Array{Any}(nothing, m)
    for i = 1:m
        a[i] = rand(R_q, n-1:n-1)
    end
    return HashContextRingSIS(q, n, m, a, R, R_q)
end

function crhfRingSIS(z, ctx::HashContextRingSIS)
    b = ctx.R(z)
    r = zero(ctx.R_q)
    for i = 1:ctx.m
        r = r + b * ctx.a[i]
    end
    return r
end
