include("sha3.jl")

function str_2_bytes(s)
    if length(s) % 2 != 0
        error("Invalid byte stream!")
    end
    B = Vector{UInt8}(undef, Int(length(s)/2))
    for i in 1: Int(length(s)/2)
        B[i] = parse(UInt8, s[2*(i-1)+1: 2*i], base=16)
    end
    return B
end

#Test SHA3
#To test, change the following flag to true
sha3_test = false
if sha3_test
    #on some environment, one might need to change the path
    #to test other functions, change the name of the file
    f = open("./lattice/src/sha3/test_vectors/SHA3_512.rsp", "r")
    len = []
    msg = []
    md = []
    for ln in readlines(f)
        if isempty(ln)
            continue
        end
        if ln[1:3] == "Len"
            push!(len, parse(Int, ln[7:end]))
        elseif ln[1:3] == "Msg"
            push!(msg, str_2_bytes(ln[7:end]))
        elseif ln[1:2] == "MD"
            push!(md, str_2_bytes(ln[6:end]))
        end
    end
    close(f)

    for i in eachindex(len)
        #to test other functions, change the name of the function
        mine = Bits_2_Bytes(SHA3_512(Bytes_2_Bits(msg[i][1:Int(len[i]/8)])))
        if mine != md[i]
            println("Uh oh.")
        end
    end
end

#Test SHAKE
#To test, change the following flag to true
shake_test = true
if shake_test
    #on some environment, one might need to change the path
    #to test other functions, change the name of the file
    f = open("./lattice/src/sha3/test_vectors/SHAKE128.rsp", "r")
    len = []
    msg = []
    md = []
    for ln in readlines(f)
        if isempty(ln)
            continue
        end
        if ln[1:9] == "Outputlen"
            push!(len, parse(Int, ln[13:end]))
        elseif ln[1:3] == "Msg"
            push!(msg, str_2_bytes(ln[7:end]))
        elseif ln[1:6] == "Output"
            push!(md, str_2_bytes(ln[10:end]))
        end
    end
    close(f)

    for i in 1:20
        #to test other functions, change the name of the function
        mine = Bits_2_Bytes(SHAKE128(len[i], Bytes_2_Bits(msg[i])))
        if mine != md[i]
            println("Uh oh.")
        end
    end
end

