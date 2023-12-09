extends SolutionBase

func part_1(input_filename: String) -> String:
	var lines := get_input_lines(input_filename)
	
	var sum := 0
	for line: String in lines:
		var readings: Array = Array(line.split(" ")).map(
			func(s: String) -> int:
				return int(s)
		)
		
		sum += predict(readings)
	
	log_message("Expected sample: 114")
	log_message("Expected input: 1789635132")
	return str(sum)

func predict(history: Array) -> int:
	if history.is_empty():
		return 0
	
	var diffs := []
	for i in range(1, history.size()):
		diffs.append(history[i] - history[i-1])
	
	return history.back() + predict(diffs)

func part_2(input_filename: String) -> String:
	return "TODO: Solve today's Part 2 using " + input_filename + ". The contents of that file are: '" + get_input_string(input_filename) + "'"

