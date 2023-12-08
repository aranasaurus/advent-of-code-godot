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
	var lines := Array(get_input_lines(input_filename))
	
	parse_directions(lines.pop_front())
	lines.pop_front() # get rid of the blank line
	
	parse_map(lines)
	
	var positions: Array[String] = []
	for key: String in map:
		if key.ends_with("A"):
			positions.append(key)
	
	var dir_step := 0
	
	var steps := directions.size()
	
	# find the path to the first target position for each start position, then find the LCM between
	# all of those path lengths. In trying to figure this out I noticed all of the path lengths were
	# evenly divisible by the directions length, which is prime, and the dividend of all of those
	# and the directions length was also prime, so our LCM is just multiplying them all together
	# with the directions length. This works for the input.txt, but not for the sample.
	for pos in positions:
		var path := path_to_next_target(pos, dir_step)
		steps *= path.size() / directions.size()
	
	log_message("Sample 3 Expected: 6")
	log_message("Input Expected: 15690466351717")
	return str(steps)

func is_target_pos(pos: String) -> bool:
	return pos.ends_with("Z")

func path_to_next_target(start_pos: String, start_dir_step: int) -> PackedByteArray:
	var pos := start_pos
	var dir_step := start_dir_step
	
	var path := PackedByteArray()
	while not is_target_pos(pos):
		pos = map[pos][directions[dir_step]]
		path.append(directions[dir_step])
		
		dir_step = advance_dir(dir_step)
	
	return path

func advance_dir(current: int, steps: int = 1) -> int:
	return (current + steps) % directions.size()
