extends SolutionBase

func part_1(input_filename):
	var lines := get_input_lines(input_filename)
	var times := parse_ints(lines[0].split(": ")[1].split(" "))
	var distances := parse_ints(lines[1].split(": ")[1].split(" "))
	
	var number_of_ways_to_win = []
	var i = 0
	while i < times.size(): # For each race (GDScript doesn't have a way to break out of an inner for loop, so we gotta go old-school.
		var count := 0
		var race_time = times[i]
		var distance_to_beat = distances[i]
		for button_time in range(race_time, 0, -1):
			var speed = button_time
			var go_time = race_time - button_time
			var distance = speed * go_time
			if distance > distance_to_beat:
				count += 1
			elif count > 0:
				# We've entered and exited the window of opportunity to win at this point, no need to calculate the remaining button_times
				number_of_ways_to_win.append(count)
				i += 1
				break
	
	var product: int = number_of_ways_to_win.reduce(
		func(accum, n):
			return accum * n \
		, 1
	)
	log_message("Expected sample result: 288")
	log_message("Epected input result: 1731600")
	return str(product)

func part_2(input_filename):
	var lines := get_input_lines(input_filename)
	var time := int(lines[0].split(": ")[1].replace(" ", ""))
	var distance := int(lines[1].split(": ")[1].replace(" ", ""))

	var count := 0
	for button_time in range(time, 0, -1):
		var speed = button_time
		var go_time = time - button_time
		var this_distance = speed * go_time
		if this_distance > distance:
			count += 1
		elif count > 0:
			# We've entered and exited the window of opportunity to win at this point, no need to calculate the remaining button_times
			break
	
	log_message("Expected sample result: 71503")
	log_message("Epected input result: 40087680")
	return str(count)

func parse_ints(strings: PackedStringArray) -> Array:
	return Array(strings) \
		.filter(func(string: String): return not string.is_empty()) \
		.map(func(string: String): return int(string))
