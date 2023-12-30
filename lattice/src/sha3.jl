function parse_len(b)
    if !(b in [25, 50, 100, 200, 400, 800, 1600])
        error("Invalid parameters!")
    end
    w = Int(b/25)
    l = Int(log(2, w))
    return w, l
end

function  arr_2_str(w, x, y, z)
    if x < 0 || y < 0 || z < 0
        error("Invalid parameters！")
    end
    return w *(5 * y + x ) + z + 1
end

function theta(w, A)
    C = BitArray(undef, 5*w)
    for x in 0:4
        for z in 0:w-1
            C[x * w + z + 1] = A[arr_2_str(w, x, 0, z)] ⊻ A[arr_2_str(w, x, 1, z)] ⊻ A[arr_2_str(w, x, 2, z)] ⊻ A[arr_2_str(w, x, 3, z)] ⊻ A[arr_2_str(w, x, 4, z)]
        end
    end
    D = BitArray(undef, 5*w)
    for x in 0:4
        for z in 0:w-1
            D[x * w + z + 1] = C[((x+4) % 5) * w + z + 1] ⊻ C[((x+1) % 5) * w + ((z + w - 1) % w) + 1]
        end
    end
    A1 = BitArray(undef, 25*w)
    for x in 0:4
        for y in 0:4
            for z in 0:w-1
                A1[arr_2_str(w, x, y, z)] = A[arr_2_str(w, x, y, z)] ⊻ D[x * w + z + 1]     
            end
        end
    end
    return A1
end

function rho(w, A)
    A1 = BitArray(undef, 25*w)
    for z in 0:w-1
        A1[arr_2_str(w, 0, 0, z)] = A[arr_2_str(w, 0, 0, z)]
    end
    x = 1
    y = 0
    for t in 0:23
        for z in 0:w-1
            A1[arr_2_str(w, x, y, z)] = A[arr_2_str(w, x, y, ((z - Int((t + 1) * (t + 2) / 2)) % w + w) % w)]
        end
        x1 = y
        y = (2 * x + 3 * y) % 5
        x = x1
    end
    return A1
end

function pi(w, A)
    A1 = BitArray(undef, 25*w)
    for x in 0:4
        for y in 0:4
            for z in 0:w-1
                A1[arr_2_str(w, x, y, z)] = A[arr_2_str(w, (x + 3 * y) % 5, x, z)]
            end
        end
    end
    return A1
end

function chi(w, A)
    A1 = BitArray(undef, 25*w)
    for x in 0:4
        for y in 0:4
            for z in 0:w-1
                A1[arr_2_str(w, x, y, z)] = A[arr_2_str(w, x, y, z)] ⊻ ((A[arr_2_str(w, (x + 1) % 5, y, z)] ⊻ 1) * A[arr_2_str(w, (x + 2) % 5, y, z)])
            end
        end
    end
    return A1
end

function rc(t)
    if t % 255 == 0
        return 1
    end
    R = BitArray([1, 0, 0, 0, 0, 0, 0, 0, 0])
    for _ in 1:t%255
        for j in 9:-1:2
            R[j] = R[j-1]
        end
        R[1] = 0
        R[1] = R[9]
        R[5] = R[5] ⊻ R[9]
        R[6] = R[6] ⊻ R[9]
        R[7] = R[7] ⊻ R[9]
    end
    return R[1]
end

function cnst(w, l, ir)
    RC = BitArray(undef, w)
    for j in 0:l
        RC[2 ^ j] = rc(j + 7 * ir)
    end
    return RC
end

function iota(w, l, ir, A)
    RC = BitArray(undef, w)
    for j in 0:l
        RC[2 ^ j] = rc(j + 7 * ir)
    end
    A1 = BitArray(undef, 25*w)
    for x in 0:4
        for y in 0:4
            for z in 0:w-1
                A1[arr_2_str(w, x, y, z)] = A[arr_2_str(w, x, y, z)]
            end
        end
    end
    for z in 0:w-1
        A1[arr_2_str(w, 0, 0, z)] = A[arr_2_str(w, 0, 0, z)] ⊻ RC[z + 1]
    end
    return A1
end

function rnd(w, l, ir, A)
    return iota(w, l, ir, chi(w, pi(w, rho(w, theta(w, A)))))
end

function keccak_p(b, nr, A)
    w, l = parse_len(b)
    A1 = BitArray(undef, b)
    for x in 0:4
        for y in 0:4
            for z in 0:w-1
                A1[arr_2_str(w, x, y, z)] = A[arr_2_str(w, x, y, z)]
            end
        end
    end
    for ir in 2*l+12-nr:2*l+11
        A1 = rnd(w, l, ir, A1)
    end
    return A1
end

function pad_10_star_1(x, m)
    j = (((- m - 2) % x) + x) % x
    z = BitArray(undef, j+2)
    z[1] = 1
    z[j+2] = 1
    for i in 2:j+1
        z[i] = 0
    end
    return z
end

function sponge(b, nr, d, r, M)
    P = vcat(M, pad_10_star_1(r, length(M)))
    n = Int(length(P)/r)
    S = BitArray(undef, b)
    for i in 1:b
        S[i] = 0
    end
    for i in 1:n
        T = BitArray(undef, b)
        for j in 1:r
            T[j] = S[j] ⊻ P[(i - 1) * r + j]
        end
        for j in r+1:b
            T[j] = S[j] ⊻ 0
        end
        S = keccak_p(b, nr, T)
    end
    Z = BitArray(undef, b)
    for i in 1:b
        Z[i] = S[i]
    end
    while length(Z) < d
        S = keccak_p(b, nr, S)
        Z = vcat(Z, S)
    end
    return Z[1:d]
end

function keccak_c(c, d, M)
    return sponge(1600, 24, d, 1600-c, M)
end

# the main hash functions

function SHA3_224(M)
    apd = BitArray([0, 1])
    M = vcat(M, apd)
    return keccak_c(448, 224, M)
end

function SHA3_256(M)
    apd = BitArray([0, 1])
    M = vcat(M, apd)
    return keccak_c(512, 256, M)
end

function SHA3_384(M)
    apd = BitArray([0, 1])
    M = vcat(M, apd)
    return keccak_c(768, 384, M)
end

function SHA3_512(M)
    apd = BitArray([0, 1])
    M = vcat(M, apd)
    return keccak_c(1024, 512, M)
end

function SHAKE128(d, M)
    apd = BitArray([1, 1, 1, 1])
    M = vcat(M, apd)
    return keccak_c(256, d, M)
end

function SHAKE256(d, M)
    apd = BitArray([1, 1, 1, 1])
    M = vcat(M, apd)
    return keccak_c(512, d, M)
end


#some helper functions

function Bits_2_Int(B)
    rt = 0
    for i in eachindex(B)
        rt *= 2
        rt += B[i]
    end
    return rt
end

function Bits_2_Byte(B)
    if length(B) != 8
        error("Wrong length!")
    end
    return UInt8(Bits_2_Int(B))
end

function Bits_2_Bytes(B)
    if length(B) % 8 != 0
        error("Error!")
    end
    n = Int(length(B)/8)
    bt = Vector{UInt8}(undef, n)
    for i in 0:n-1
        bt[i+1] = Bits_2_Byte(reverse(B[8*i+1:8*i+8]))
    end
    return bt
end

function Byte_2_Bits(B)
    R = BitArray(undef, 8)
    for i in 1:8
        R[i] = B % 2
        B = floor(Int, B/2)
    end
    return R
end

function Bytes_2_Bits(B)
    R = BitArray([])
    for i in eachindex(B)
        R = vcat(R, Byte_2_Bits(B[i]))
    end
    return R
end


#an example
#M = Bytes_2_Bits(b"this code is brilliant")
#h = SHA3_512(M)
#println(Bits_2_Bytes(h))

