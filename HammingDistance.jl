function hammingdist(arg_1,arg_2)
    #check types
    if typeof(arg_1) != typeof(arg_2)
        throw(ArgumentError("Type mismatch: type of arg_1 is $(typeof(arg_1)) but type of arg_2 is $(typeof(arg_2))."))
    elseif !(typeof(arg_1) <: String || typeof(arg_1) <: Array)
        throw(ArgumentError("Unsupported arguments: expecting Array or String but got $(typeof(arg_1))."))
    end

    #check length
    if length(arg_1) != length(arg_2)
        throw(ArgumentError("Length mismatch: length of arg_1 is $(length(arg_1)) but length of arg_2 is $(length(arg_2))."))
    end

    #compute distance
    counter = 0
    for i in eachindex(arg_1)
        if arg_1[i] != arg_2[i]
            counter = counter + 1
        end
    end
    return counter
end


a = ["bilibabu",2.345,'c',[[π]]]
b = ["bilibabu",[2.345],'c', [[π]]]
try
    println(hammingdist(a,b))
catch e
    println(e.msg)
end