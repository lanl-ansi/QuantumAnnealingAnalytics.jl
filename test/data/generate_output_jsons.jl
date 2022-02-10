using QuantumAnnealing

qa_json_path = joinpath(dirname(pathof(QuantumAnnealing)), "..")
bqp1 = "$(qa_json_path)/test/data/bqpjson_1q.json"
bqp2 = "$(qa_json_path)/test/data/bqpjson_2q.json"
dwout1 = "dwisc_1q.json"
dwout2 = "dwisc_2q.json"

simulate_bqpjson(bqp1, dwout1, 100, AS_CIRCULAR, 1000)
simulate_bqpjson(bqp2, dwout2, 100, AS_CIRCULAR, 1000)
