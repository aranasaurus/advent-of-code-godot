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
		
		var number_of_matches := count_matches(winning_numbers, card_numbers)
		if number_of_matches > 0:
			winning_cards.append(number_of_matches)
		
	var sum := 0
	for number_of_matches: int in winning_cards:
		sum += int(pow(2, number_of_matches - 1))
	
	log_message("Expected sample answer: 13")
	log_message("Expected input answer: 32609")
	return str(sum)

func parse_numbers(numbers: PackedStringArray) -> Array:
	var arr = Array(numbers).map(func(s: String): return s.strip_edges())
	arr = arr.filter(func(s: String): return not s.is_empty())
	return arr.map(func(s: String): return int(s))

func part_2(input_filename: String) -> String:
	var lines := get_input_lines(input_filename)
	
	var copy_map = {}
	var card_count := 0
	for card: String in lines:
		var card_id := int(card.split(": ")[0].replace("Game ", ""))
		card = card.split(": ")[1]
		var winning_numbers = card.split(" | ")[0].split(" ")
		winning_numbers = parse_numbers(winning_numbers)
		var card_numbers = card.split(" | ")[1].split(" ")
		card_numbers = parse_numbers(card_numbers)
		
		# Count this card's copies
		var card_copies := 1
		if copy_map.has(card_id):
			card_copies += copy_map[card_id]
			card_count += card_copies
		else:
			card_count += 1
		
		# Add 1 copy for each following card based on the number of matching numbers on this card
		var number_of_matches := count_matches(winning_numbers, card_numbers)
		if number_of_matches > 0:
			for i in range(number_of_matches):
				var copy_id = card_id + i + 1
				if copy_map.has(copy_id):
					copy_map[copy_id] += card_copies
				else:
					copy_map[copy_id] = card_copies
	
	log_message("Expected sample answer: 30")
	log_message("Expected input answer: 14624680")
	return str(card_count)

func count_matches(winning_numbers: Array, card_numbers: Array) -> int:
	var number_of_matches := 0
	for winning_number in winning_numbers:
		if card_numbers.has(winning_number):
			number_of_matches += 1
	return number_of_matches
