extends SolutionBase

class Game:
	var id: int
	var red: int = 0
	var green: int = 0
	var blue: int = 0
	
	func _init(line: String) -> void:
		var id_and_rounds = line.split(": ")
		id = int(id_and_rounds[0].replace("Game ", ""))
		
		var rounds = id_and_rounds[1].split("; ")
		for round in rounds:
			var pairings = round.split(", ")
			for pairing in pairings:
				var num = int(pairing.split(" ")[0])
				var color = pairing.split(" ")[1]
				self[color] = max(self[color], num)
	
	func is_possible(red_limit: int, green_limit: int, blue_limit: int) -> bool:
		return red <= red_limit and green <= green_limit and blue <= blue_limit

func part_1(input_filename: String) -> String:
	var lines = get_input_lines(input_filename)
	
	var red_max := 12
	var green_max := 13
	var blue_max := 14
	
	var sum := 0
	for line: String in lines:
		print(line)
		var g := Game.new(line)
		if g.is_possible(red_max, green_max, blue_max):
			print("^ is possible " + str(g.id))
			sum += g.id
	
	return str(sum)

func part_2(input_filename: String) -> String:
	return "TODO: Solve today's Part 2 using " + input_filename + ". The contents of that file are: '" + get_input_string(input_filename) + "'"

