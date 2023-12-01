extends Node

var input_dir: String:
	get:
		return get_script().resource_path.get_base_dir()

func part_1(input_filename: String):
	var lines := get_input_string(input_filename).split("\n")
	var number_lines = Array(lines).map(func(line: String):
		var numbers := []
		for c in line:
			if c.is_valid_int():
				numbers.append(c)
		return numbers
	)
	print(number_lines)
	
	var numbers := []
	for line: Array in number_lines:
		numbers.append(line.front() + line.back())
	print(numbers)
	
	var sum: int = numbers.reduce(convert_to_int_and_sum, 0)
	print(sum)

func convert_to_int_and_sum(sum: int, n: String) -> int:
	return sum + int(n)

func get_input_string(input_filename: String) -> String:
	var path = input_dir + "/" + input_filename
	print("Parsing %s" % path)
	
	return FileAccess.get_file_as_string(path).strip_edges().replace("\r\n", "\n")
