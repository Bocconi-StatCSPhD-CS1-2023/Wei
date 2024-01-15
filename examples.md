first do: using lattice



(1) sha3 hash function

M = Bytes_2_Bits(b"this code is brilliant")
h = SHA3_256(M)
println(Bits_2_Bytes(h))

the result can be compared with the tool on https://emn178.github.io/online-tools/sha3_256.html

(2) sha3 extendable output function
M = Bytes_2_Bits(b"this code is brilliant")
h = SHAKE128(1024, M)
println(Bits_2_Bytes(h))

the result can be compared with the tool on https://emn178.github.io/online-tools/shake_128.html





(3) SIS hash function
#first initialize the context
#in the example, a random input is generated

ctx = HashContextSIS(43, 14, 43) 
z = rand(0:ctx.q-1, ctx.m) 
println(crhfSIS(z, ctx)) 


(4) RingSIS hash function
#first initialize a polynomial ring and initialize the context
#the parameters are specially selected for the algorithm to work, it's better not to change them
#in the example, a random input is generated

r = PolyRing(12289, 1024, 12277, 3263, 9089) 
ctx = HashContextRingSIS(5, r) 
z = Vector{Vector{Int}}(undef, ctx.m) 
for i in 1:ctx.m
    z[i] = rand(1:r.q, r.n)
end 
h = crhfRingSIS_NTT(z, ctx) 




(5) Brute Force polynomial mutiplcation
#first initialize the polynomial ring
#the parameters are specially selected for the algorithm to work, it's better not to change them
#two random inputs x and y are generated

r = PolyRing(12289, 1024, 12277, 3263, 9089)
x = zeros(Int, r.n)
y = zeros(Int, r.n)
for i in 1: r.n
    x[i] = rand(0:r.q-1)
    y[i] = rand(0:r.q-1)
end
z = mult(x, y, r)
println(z)




(6) NTT based multiplication
#first initialize the polynomial ring
#the parameters are specially selected for the algorithm to work, it's better not to change them
#two random inputs x and y are generated


r = PolyRing(12289, 1024, 12277, 3263, 9089)
x = zeros(Int, r.n)
y = zeros(Int, r.n)
for i in 1: r.n
    x[i] = rand(0:r.q-1)
    y[i] = rand(0:r.q-1)
end
z = NTT_mult_nega(x, y, r)
println(z)


#for (5) and (6) one should check that if the same x and y are used then the results are the same
#in crhf/test.jl, there are codes that check this