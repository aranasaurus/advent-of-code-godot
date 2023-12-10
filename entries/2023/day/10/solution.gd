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
	var lines := get_input_lines(input_filename)
	
	var start_pos := find_start(lines)
	var loop_points := PackedVector2Array()
	loop_points.append(start_pos)
	var next_pos = get_next_pos(start_pos, lines, start_pos)
	var prev_pos = start_pos
	while next_pos != null and next_pos != start_pos:
		loop_points.append(next_pos)
		var current_pos = next_pos
		next_pos = get_next_pos(current_pos, lines, prev_pos)
		prev_pos = current_pos
	
	replace_start_char(start_pos, lines)
	
	var result := 0
	var width = lines[0].length()
	var height = lines.size()
	for y in height:
		var crossings := 0
		var prev_crossing
		var loc := Vector2(0, y)
		for x in width:
			loc.x = x
			var c = lines[y][x]
			if c in "|FLJ7":
				if loc in loop_points:
					if prev_crossing != null and c in "J7":
						match prev_crossing:
							"F":
								if c != "J":
									crossings += 1
							"L":
								if c != "7":
									crossings += 1
					else:
						crossings += 1
					
					if c in "FL":
						prev_crossing = c
				elif crossings % 2 == 1:
					result += 1
			elif crossings % 2 == 1 and (c == "." or not loc in loop_points):
				result += 1
	
	log_message("Expected simple: 4")
	log_message("Expected complex: 10")
	log_message("Expected input: 511")
	return str(result)

func find_start(lines: PackedStringArray) -> Vector2i:
	for y in lines.size():
		var line: String = lines[y]
		for x in line.length():
			if line[x] == "S":
				return Vector2i(x, y)
	return Vector2i.ZERO

const north_connectors := "|JLS"
const south_connectors := "|F7S"
const east_connectors := "-FLS"
const west_connectors := "-J7S"
const polygon_connectors := "SJLF7"

func replace_start_char(start_pos: Vector2i, lines: PackedStringArray):
	var first = get_next_pos(start_pos, lines, start_pos) as Vector2i
	var second = get_next_pos(start_pos, lines, first) as Vector2i
	
	var replacement = lines[start_pos.y][start_pos.x]
	if first.x < start_pos.x:
		if second.x > start_pos.x:
			replacement = "-"
		elif second.y > start_pos.y:
			replacement = "7"
		else:
			replacement = "J"
	elif first.x > start_pos.x:
		if second.x < start_pos.x:
			replacement = "-"
		elif second.y > start_pos.y:
			replacement = "F"
		else:
			replacement = "L"
	elif first.y < start_pos.y:
		if second.x < start_pos.x:
			replacement = "J"
		elif second.x > start_pos.x:
			replacement = "L"
		else:
			replacement = "|"
	elif first.y > start_pos.y:
		if second.x < start_pos.x:
			replacement = "7"
		elif second.x > start_pos.x:
			replacement = "F"
		else:
			replacement = "|"
	lines[start_pos.y][start_pos.x] = replacement

func get_next_pos(pos: Vector2i, lines: PackedStringArray, prev_pos: Vector2i):
	var source := lines[pos.y][pos.x]
	
	var n_pos = Vector2i(pos.x, pos.y - 1)
	var s_pos = Vector2i(pos.x, pos.y + 1)
	var e_pos = Vector2i(pos.x + 1, pos.y)
	var w_pos = Vector2i(pos.x - 1, pos.y)
	
	if pos.y > 0 and prev_pos != n_pos:
		if north_connectors.contains(source) and south_connectors.contains(lines[n_pos.y][n_pos.x]):
			return n_pos
	if pos.x < lines[0].length() - 1 and prev_pos != e_pos:
		if east_connectors.contains(source) and west_connectors.contains(lines[e_pos.y][e_pos.x]):
			return e_pos
	if pos.y < lines.size() and prev_pos != s_pos:
		if south_connectors.contains(source) and north_connectors.contains(lines[s_pos.y][s_pos.x]):
			return s_pos
	if pos.x > 0 and prev_pos != w_pos:
		if west_connectors.contains(source) and east_connectors.contains(lines[w_pos.y][w_pos.x]):
			return w_pos
	
	return null

class Tile:
	var source: String
	var pos: Vector2i
	var is_loop_edge := false
	
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
