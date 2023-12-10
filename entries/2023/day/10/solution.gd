extends SolutionBase

func part_1(input_filename: String) -> String:
	var lines := get_input_lines(input_filename)
	
	var map := {}
	var pos = Vector2i.ZERO
	var start_pos := Vector2i.ZERO
	for y in range(lines.size()):
		var line = lines[y]
		pos.y = y
		for x in range(line.length()):
			pos.x = x
			var t := Tile.new()
			t.source = line[x]
			t.pos = pos
			
			if t.source != ".":
				if x > 0:
					var west = pos - Vector2i(1, 0)
					if map.has(west):
						map[west].e = t
						t.w = map[west]
					
				if x < line.length() - 1:
					var east = pos + Vector2i(1, 0)
					if map.has(east):
						map[east].w = t
						t.e = map[east]
				
				if y > 0:
					var north = pos - Vector2i(0, 1)
					if map.has(north):
						map[north].s = t
						t.n = map[north]
				
				if y < lines.size() - 1:
					var south = pos + Vector2i(0, 1)
					if map.has(south):
						map[south].n = t
						t.s = map[south]
				
				map[pos] = t
			
			if t.source == "S":
				start_pos = pos
	
	var result := 1
	var start_tile = map[start_pos]
	var previous_tile = start_tile
	var current_tile = previous_tile.next(start_tile)
	while current_tile != start_tile:
		result += 1
		var next_tile = current_tile.next(previous_tile)
		previous_tile = current_tile
		current_tile = next_tile
	result /= 2
	
	log_message("Expected simple: 4")
	log_message("Expected complex: 8")
	log_message("Expected input: 6613")
	return str(result)

func part_2(input_filename: String) -> String:
	return "TODO: Solve today's Part 2 using " + input_filename + ". The contents of that file are: '" + get_input_string(input_filename) + "'"

class Tile:
	var source: String
	var pos: Vector2i
	
	var e
	var w
	var n
	var s
	
	func next(after: Tile):
		if source == "S":
			if n: return n
			if e: return e
			if s: return s
			if w: return w
		
		match source:
			"|":
				if after == n: return s
				else: return n
			"-":
				if after == w: return e
				else: return w
			"L": 
				if after == n: return e
				else: return n
			"J":
				if after == n: return w
				else: return n
			"7":
				if after == w: return s
				else: return w
			"F":
				if after == e: return s
				else: return e
