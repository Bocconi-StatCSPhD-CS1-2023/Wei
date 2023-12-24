function parse_len(b)
    if !(b in [25, 50, 100, 200, 400, 800, 1600])
        error("Invalid parameters!")
    end
    w = Int(b/25)
    l = Int(log(2, w))
    return w, l
end

function  arr_2_str(w, x, y, z)
    return w *(5 * y + x ) + z + 1
end

function  str_2_arr(w, idx)
    idx = idx - 1
    z = idx % w
    y = floor(Int, idx / (5 * w))
    x = floor(Int, (idx % (5 * w))/w)
    return x, y, z
end

function theta(w, A::BitArray)
    B = BitArray(A)
    for x in 0:4
        for z in 0:w-1 
        end
    end
end
