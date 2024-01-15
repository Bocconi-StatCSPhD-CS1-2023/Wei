using Random

include("ring.jl")
r = PolyRing(12289, 1024, 12277, 3263, 9089) #initialize the ring

x = zeros(Int, r.n) #generate two random polynomials
y = zeros(Int, r.n)
for i in 1: r.n
    x[i] = Random.rand(0:r.q-1)
    y[i] = Random.rand(0:r.q-1)
end

z1 = mult(x, y, r) #compute the multiplication by brute force
z2 = NTT_mult_nega(x, y, r) #compute the multiplication by NTT
for i in 1:r.n #compare the results, which should be the same
    if z1[i] != z2[i]
        println("Uh oh.")
    end
end