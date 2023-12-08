extends SolutionBase

@export var map := {}
@export var directions := PackedByteArray()

func part_1(input_filename: String) -> String:
	var lines := Array(get_input_lines(input_filename))
	
	lines.pop_front() # get rid of the blank line
	
	parse_map(lines)
	
	var pos := "AAA"
	var dir_step := 0
	var target := "ZZZ"
	
	var steps := 0
	while pos != target:
		steps += 1
		var dir_index := directions[dir_step]
		pos = map[pos][dir_index]
		
		dir_step = advance_dir(dir_step)
	
	log_message("Sample 1 Expected: 2")
	log_message("Sample 2 Expected: 6")
	log_message("Input Expected: 20659")
	return str(steps)

func parse_map(lines: PackedStringArray) -> void:
	for line: String in lines:
		var sides := line.split(" = ")
		map[sides[0]] = sides[1].replace("(", "").replace(")", "").split(", ")

func parse_directions(line: String) -> void:
	directions = PackedByteArray()
	for c in line:
		directions.append("LR".find(c))


func part_2(input_filename: String) -> String:
	return "TODO"
	

func is_target_pos(pos: String) -> bool:
	return pos.ends_with("Z")

func advance_dir(current: int, steps: int = 1) -> int:
	return current + steps % directions.size()
