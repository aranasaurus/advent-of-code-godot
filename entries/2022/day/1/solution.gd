extends SolutionBase

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
