class_name SolutionBase
extends Node

var input_dir: String:
	get:
		return get_script().resource_path.get_base_dir()

var logger: Callable

func get_input_lines(input_filename: String) -> PackedStringArray:
	return get_input_string(input_filename).split("\n")

func get_input_string(input_filename: String) -> String:
	var path = input_dir + "/" + input_filename
	
	return FileAccess.get_file_as_string(path) \
		.strip_edges() \
		.replace("\r\n", "\n")

func part_1(_input_filename: String) -> String:
	return "You need to override func `part_1(input_filename: String) -> String` in your subclass. There's no need to call super."

func part_2(_input_filename: String) -> String:
	return "You need to override `func part_2(input_filename: String) -> String` in your subclass. There's no need to call super."

func log_message(message: String) -> void:
	logger.call(message)
