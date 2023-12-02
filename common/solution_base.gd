class_name SolutionBase
extends Node

var input_dir: String:
	get:
		return get_script().resource_path.get_base_dir()

func get_input_lines(input_filename: String) -> PackedStringArray:
	return get_input_string(input_filename).split("\n")

func get_input_string(input_filename: String) -> String:
	var path = input_dir + "/" + input_filename
	
	return FileAccess.get_file_as_string(path) \
		.strip_edges() \
		.replace("\r\n", "\n")

func part_1(input_filename: String) -> String:
	return "You need to override this function in your subclass"

func part_2(input_filename: String) -> String:
	return "You need to override this function in your subclass"
