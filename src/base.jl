function spin2int(spin)
    return _QA.binary2int(spin2binary(spin))
end

function int2spin(int;pad=pad)
    return _QA.binary2spin(_QA.int2binary(int,pad=pad))
end

function spin2binary(spin)
    return [i == 1 ? 0 : 1 for i in spin]
end

function spin_hamming_distance(spin_1, spin_2)
    x = spin2int(spin_1)
    y = spin2int(spin_2)

    #Kernighan's Algorithm
    diff_bits = xor(x,y)
    hamming_dist = 0
    while diff_bits != 0
        hamming_dist += 1
        diff_bits = diff_bits & (diff_bits-1)
    end
    return hamming_dist
end
