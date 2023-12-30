include("../ring.jl")

struct HashContextRingSIS
    m::Int
    a::Vector{Vector{Int}}
    r::PolyRing
end

function HashContextRingSIS(m, r)
    a = Vector{Vector{Int}}(undef, m)
    for i in 1:m
        a[i] = Random.rand(1:r.q, r.n)
    end
    return HashContextRingSIS(m, a, r)
end

function crhfRingSIS(z, ctx::HashContextRingSIS)
    r = zeros(Int, ctx.r.n)
    for i in 1:ctx.m
        t = mult(z, ctx.a[i], ctx.r)
        for j in 1:ctx.r.n
            r[j] += t[j]
            r[j] = r[j] % ctx.r.q
        end
    end
    return r
end

function crhfRingSIS_NTT(z, ctx::HashContextRingSIS)
    r = zeros(Int, ctx.r.n)
    for i in 1:ctx.m
        t = NTT_mult_nega(z, ctx.a[i], ctx.r)
        for j in 1:ctx.r.n
            r[j] += t[j]
            r[j] = r[j] % ctx.r.q
        end
    end
    return r
end

#an example
#r = PolyRing(12289, 1024, 12277, 3263, 9089)
#ctx = HashContextRingSIS(5, r)
