extends SolutionBase

func part_1(input_filename: String) -> String:
	var lines := get_input_lines(input_filename)
	
	var winning_cards = []
	for card: String in lines:
		# Chop off the "Game X: "
		card = card.split(": ")[1]
		var winning_numbers = card.split(" | ")[0].split(" ")
		winning_numbers = parse_numbers(winning_numbers)
		var card_numbers = card.split(" | ")[1].split(" ")
		card_numbers = parse_numbers(card_numbers)
		
		# TODO: Optimize this? Doesn't seem like GDScript has Sets so it'll only be worth it if the performance of this solution is slow enough to make it necessary
		var number_of_matches := 0
		for winning_number in winning_numbers:
			if card_numbers.has(winning_number):
				number_of_matches += 1
		if number_of_matches > 0:
			winning_cards.append(number_of_matches)
		
	var sum := 0
	for number_of_matches: int in winning_cards:
		sum += int(pow(2, number_of_matches - 1))
	
	log_message("Expected sample answer: 13")
	return str(sum)

func parse_numbers(numbers: PackedStringArray) -> Array:
	var arr = Array(numbers).map(func(s: String): return s.strip_edges())
	arr = arr.filter(func(s: String): return not s.is_empty())
	return arr.map(func(s: String): return int(s))

func part_2(input_filename: String) -> String:
	return "TODO: Solve today's Part 2 using " + input_filename + ". The contents of that file are: '" + get_input_string(input_filename) + "'"

