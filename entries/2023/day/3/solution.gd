extends SolutionBase

var symbol_locations := {}
var row_width := 0

func part_1(input_filename: String) -> String:
	var string := get_input_string(input_filename)\
		.replace("\n", "") # strip newlines, they screw with the coordinate conversion
	row_width = get_input_lines(input_filename)[0].length()
	
	var digit_regex := RegEx.new()
	digit_regex.compile(r"\d+")
	var symbol_regex := RegEx.new()
	symbol_regex.compile(r"[^a-zA-Z0-9.\n]")

	symbol_locations.clear()
	for result in symbol_regex.search_all(string):
		var pos := get_position(result.get_start())
		if not symbol_locations.has(pos.y):
			symbol_locations[pos.y] = []
		symbol_locations[pos.y].append(pos.x)
	
	var sum := 0
	for result in digit_regex.search_all(string):
		if is_part_number(result):
			sum += int(result.get_string())
	
	log_message("Sample answer should be 4361")
	return str(sum)

func get_position(i: int) -> Vector2i:
	var pos := Vector2i(i % row_width, floor(i / row_width))
	return pos

func is_part_number(result: RegExMatch):
	for i in range(result.get_start(), result.get_end()):
		var loc := get_position(i)
		for y in range(max(loc.y - 1, 0), loc.y + 2):
			if symbol_locations.has(y):
				for symbol_x in symbol_locations[y]:
					if abs(loc.x - symbol_x) <= 1:
						return Vector2i(symbol_x, y)

func part_2(input_filename: String) -> String:
	var string := get_input_string(input_filename)\
		.replace("\n", "") # strip newlines, they screw with the coordinate conversion
	row_width = get_input_lines(input_filename)[0].length()
	
	var digit_regex := RegEx.new()
	digit_regex.compile(r"\d+")
	var symbol_regex := RegEx.new()
	symbol_regex.compile(r"\*")

	symbol_locations.clear()
	var gear_ratios := {}
	for result in symbol_regex.search_all(string):
		var pos := get_position(result.get_start())
		if not symbol_locations.has(pos.y):
			symbol_locations[pos.y] = []
		symbol_locations[pos.y].append(pos.x)
		gear_ratios[pos] = []
	
	var sum := 0
	for result in digit_regex.search_all(string):
		var gear = is_part_number(result)
		if gear:
			gear_ratios[gear].append(int(result.get_string()))
	
	for key in gear_ratios:
		var gear = gear_ratios[key]
		if gear.size() == 2:
			sum += gear[0] * gear[1]
	
	log_message("Sample answer should be 467835")
	return str(sum)

