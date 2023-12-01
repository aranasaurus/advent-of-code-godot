extends Node
class_name Solution2022Day1

var input_dir: String:
	get:
		return get_script().resource_path.get_base_dir()

func part_1(input_filename: String):
	var calories := get_calories(input_filename)
	print(calories.max())

func part_2(input_filename: String):
	var calories := get_calories(input_filename)
	calories.sort()
	
	var top_three_sum = calories \
		.slice(calories.size() - 3, calories.size()) \
		.reduce(func(a, b): return a + b, 0)
	
	print(top_three_sum)
	
func get_calories(input_filename: String) -> Array:
	var input = get_input_string(input_filename)
	var elves = input.split("\n\n")
	
	var calories := []
	for elf in elves:
		var elf_calories := 0
		for s in elf.split("\n"):
			elf_calories += int(s)
		calories.append(elf_calories)
	
	return calories
	
func get_input_string(input_filename: String) -> String:
	var path = input_dir + "/" + input_filename
	print("Parsing %s" % path)
	
	return FileAccess.get_file_as_string(path).strip_edges().replace("\r\n", "\n")
