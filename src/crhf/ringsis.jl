include("ring.jl")
using Random

struct HashContextRingSIS
    m::Int
    a::Vector{Vector{Int}}
    r::PolyRing
end

function HashContextRingSIS(m::Int, r::PolyRing)
    a = Vector{Vector{Int}}(undef, m)
    for i in 1:m
        a[i] = Random.rand(1:r.q, r.n)
    end
    return HashContextRingSIS(m, a, r)
end

function crhfRingSIS(z::Vector{Vector{Int}}, ctx::HashContextRingSIS)
    r = zeros(Int, ctx.r.n)
    for i in 1:ctx.m
        t = mult(z[i], ctx.a[i], ctx.r)
        for j in 1:ctx.r.n
            r[j] += t[j]
            r[j] = r[j] % ctx.r.q
        end
    end
    return r
end

function crhfRingSIS_NTT(z::Vector{Vector{Int}}, ctx::HashContextRingSIS)
    r = zeros(Int, ctx.r.n)
    for i in 1:ctx.m
        t = NTT_mult_nega(z[i], ctx.a[i], ctx.r)
        for j in 1:ctx.r.n
            r[j] += t[j]
            r[j] = r[j] % ctx.r.q
        end
    end
    return r
end

#an example
#r = PolyRing(12289, 1024, 12277, 3263, 9089) #initialize the ring
#ctx = HashContextRingSIS(5, r) #initialize the context
#z = Vector{Vector{Int}}(undef, ctx.m) #randomly generate an input to the hash function
#for i in 1:ctx.m
#    z[i] = Random.rand(1:r.q, r.n)
#end 
#h = crhfRingSIS_NTT(z, ctx) #compute the hash function
