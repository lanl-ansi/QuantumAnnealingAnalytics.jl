function ising2int(ising)
    return QuantumAnnealing.binary2int(ising2binary(ising))
end

function int2ising(ising;pad=pad)
    return QuantumAnnealing.binary2ising(QuantumAnnealing.int2binary(ising,pad=pad))
end

function ising2binary(ising)
    return [i == 1 ? 0 : 1 for i in ising]
end

function ising_hamming_distance(ising_1, ising_2)
    x = ising2int(ising_1)
    y = ising2int(ising_2)

    #Kernighan's Algorithm
    diff_bits = xor(x,y)
    hamming_dist = 0
    while diff_bits != 0
        hamming_dist += 1
        diff_bits = diff_bits & (diff_bits-1)
    end
    return hamming_dist
end
