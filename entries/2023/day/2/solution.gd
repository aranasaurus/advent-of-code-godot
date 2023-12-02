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
	
	var power: int:
		get:
			return red * green * blue

func part_1(input_filename: String) -> String:
	var games := parse_games(input_filename)
	
	var sum := 0
	for game: Game in games:
		if game.is_possible(12, 13, 14):
			sum += game.id
	
	return str(sum)

func part_2(input_filename: String) -> String:
	var games := parse_games(input_filename)
	
	var sum := 0
	for game: Game in games:
		sum += game.power
	
	return str(sum)

func parse_games(input_filename: String) -> Array:
	var lines = get_input_lines(input_filename)
	
	var games := []
	for line: String in lines:
		games.append(Game.new(line))
	return games
