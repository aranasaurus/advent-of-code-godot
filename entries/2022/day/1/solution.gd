extends Node
class_name Solution2022Day1

var input_dir: String:
	get:
		return get_script().resource_path.get_base_dir()

func run(input_filename: String):
	var path = input_dir + "/" + input_filename
	print("Parsing %s" % path)
	
	var input = FileAccess.get_file_as_string(path).strip_edges().replace("\r\n", "\n")
	
	var elves = input.split("\n\n")
	
	var calories := []
	for elf in elves:
		var elf_calories := 0
		for s in elf.split("\n"):
			elf_calories += int(s)
		calories.append(elf_calories)
	
	print(calories.max())
