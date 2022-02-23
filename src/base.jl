function spin_hamming_distance(spin_1, spin_2)
    x = _QA.spin2int(spin_1)
    y = _QA.spin2int(spin_2)

    #Kernighan's Algorithm
    diff_bits = xor(x,y)
    hamming_dist = 0
    while diff_bits != 0
        hamming_dist += 1
        diff_bits = diff_bits & (diff_bits-1)
    end
    return hamming_dist
end
