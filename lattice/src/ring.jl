struct PolyRing
    q::Int
    n::Int
    ni::Int
    ϕ::Int
    ϕi::Int
    W::Vector{Int}
    WI::Vector{Int}
    Φ::Vector{Int}
    ΦI::Vector{Int}
end

function PolyRing(q, n, ni, w, ϕ)
    W = Vector{Int}(undef, n)
    W[1] = 1
    for i in 2:n
        W[i] = (W[i-1] * w) % q
    end

    WI = Vector{Int}(undef, n)
    wi = W[n]
    WI[1] = 1
    for i in 2:n
        WI[i] = (WI[i-1] * wi) % q
    end

    Φ = Vector{Int}(undef, n)
    Φ[1] = 1
    for i in 2:n
        Φ[i] = (Φ[i-1] * ϕ) % q
    end

    ΦI = Vector{Int}(undef, n)
    ϕi = ((Φ[n]^2 % q) * ϕ) % q
    ΦI[1] = 1
    for i in 2:n
        ΦI[i] = (ΦI[i-1] * ϕi) % q
    end
    return PolyRing(q, n, ni, ϕ, ϕi, W, WI, Φ, ΦI)
end

#Canonical Multiplication, for variation
function mult(x, y, r)
    z = zeros(Int, r.n)
    for i in eachindex(x)
        for j in eachindex(y)
            d = i + j - 2
            if d >= r.n
                d = d - r.n + 1
                z[d] -= x[i]*y[j] % r.q
            else
                d = d + 1
                z[d] += (x[i]*y[j] + r.q) % r.q
            end 
            z[d] = (z[d] + r.q) % r.q
        end
    end
    return z
end

#NTT 
function NTT(a, r)
    b = zeros(Int, r.n)
    for i in 1:r.n 
        tmp_w = 1
        for j in 1:r.n
            b[i] += a[j] * tmp_w
            b[i] = b[i] % r.q
            tmp_w = (tmp_w * r.W[i]) % r.q
        end
    end
    return b
end

#Inverse NTT
function INTT(b, r)
    a = zeros(Int, r.n)
    for i in 1:r.n 
        tmp_wi = 1
        for j in 1:r.n 
            a[i] += b[j] * tmp_wi
            a[i] = a[i] % r.q
            tmp_wi = (tmp_wi * r.WI[i]) % r.q
        end
        a[i] = (a[i] * r.ni) % r.q
    end
    return a
end

#NTT multiplication, support half of the range
function NTT_mult(x,y,r)
    a = NTT(x, r)
    b = NTT(y, r)
    c = Vector{Int}(undef, r.n)
    for i in 1:r.n
        c[i] = (a[i] * b[i]) % r.q
    end
    return INTT(c, r)
end

#NTT multiplication, support full range
function NTT_mult_nega(x, y, r)
    a = zeros(Int, r.n)
    b = zeros(Int, r.n)
    c = zeros(Int, r.n)
    for i in 1:r.n
        a[i] = (x[i] * r.Φ[i]) % r.q 
        b[i] = (y[i] * r.Φ[i]) % r.q
    end
    t = NTT_mult(a, b, r)
    for i in 1:r.n
        c[i] = (t[i] * r.ΦI[i]) % r.q
    end
    return c
end

#an example
#r = PolyRing(12289, 1024, 12277, 3263, 9089)

#print(mult([1,2,3], [4,5,6], r))
#x = zeros(Int, r.n)
#y = zeros(Int, r.n)
#for i in 1:round(Int, r.n)
#    x[i] = i
#    y[i] = 2*i
#end

#z1 = mult(x, y, r)
#z2 = NTT_mult(x, y, r)
#z3 = NTT_mult_nega(x, y, r)
#for i in 1:r.n
#    println(z1[i])
#    println(z2[i])
#    println(z3[i])
#    println()
#end