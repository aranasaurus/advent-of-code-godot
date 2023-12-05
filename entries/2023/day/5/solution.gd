extends SolutionBase

class Map:
	var chunks: Array # of MapChunks
	var next_map: Map
	
	func size() -> int:
		return chunks.size()
	
	func destination(source: int) -> int:
		for chunk: MapChunk in chunks:
			if source >= chunk.source_start and source < chunk.source_end:
				return chunk.destination_start + (source - chunk.source_start)
		return source
	
	func traverse(source: int) -> int:
		var next_source = destination(source)
		#print(source, " -> ", next_source)
		if next_map == null:
			return next_source
		else:
			return next_map.traverse(next_source)
	
	static func parse(lines: PackedStringArray, start_index: int) -> Map:
		var line = lines[start_index]
		var map = Map.new()
		map.chunks = []
		var i = start_index
		while not line.is_empty() and i < lines.size():
			map.chunks.append(MapChunk.parse(line))
			
			i += 1
			if i >= lines.size():
				break
			line = lines[i]
		return map

class MapChunk:
	var destination_start: int
	var destination_end: int:
		get: return destination_start + length
	var source_start: int
	var source_end: int:
		get: return source_start + length
	var length: int
	
	static func parse(line: String) -> MapChunk:
		var numbers = PackedInt64Array(Array(line.split(" ")))
		var m = MapChunk.new()
		m.destination_start = numbers[0]
		m.source_start = numbers[1]
		m.length = numbers[2]
		return m

func part_1(input_filename: String) -> String:
	var lowest_loc := 1000000000
	var lines := get_input_lines(input_filename)
	var initial_seeds = parse_initial_seeds(lines)
	
	var i := 3
	var seed_soil_map = Map.parse(lines, i)
	i += seed_soil_map.size() + 2
	var soil_fertilizer_map = Map.parse(lines, i)
	i += soil_fertilizer_map.size() + 2
	var fertilizer_water_map = Map.parse(lines, i)
	i += fertilizer_water_map.size() + 2
	var water_light_map = Map.parse(lines, i)
	i += water_light_map.size() + 2
	var light_temp_map = Map.parse(lines, i)
	i += light_temp_map.size() + 2
	var temp_humidity_map = Map.parse(lines, i)
	i += temp_humidity_map.size() + 2
	var humidity_loc_map = Map.parse(lines, i)
	
	seed_soil_map.next_map = soil_fertilizer_map
	soil_fertilizer_map.next_map = fertilizer_water_map
	fertilizer_water_map.next_map = water_light_map
	water_light_map.next_map = light_temp_map
	light_temp_map.next_map = temp_humidity_map
	temp_humidity_map.next_map = humidity_loc_map
	
	for seed in initial_seeds:
		var location = seed_soil_map.traverse(seed)
		if location < lowest_loc:
			lowest_loc = location
		print(seed, ": ", location)
	
	log_message("Expected sample answer: 35")
	log_message("Expected input answer: 424490994")
	return str(lowest_loc)

func parse_initial_seeds(lines: PackedStringArray) -> PackedInt64Array:
	var seeds_str = lines[0].replace("seeds: ", "").strip_edges().split(" ")
	return PackedInt64Array(Array(seeds_str))

func part_2(input_filename: String) -> String:
	return "TODO: Solve today's Part 2 using " + input_filename + ". The contents of that file are: '" + get_input_string(input_filename) + "'"

