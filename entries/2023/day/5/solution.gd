extends SolutionBase

class OverlapSeed:
	var start: int
	var end: int
	
	static func find_overlap(chunks: Array, source_start: int, source_end: int):
		for chunk: MapChunk in chunks:
			if source_start > chunk.source_end or source_end < chunk.source_start:
				continue
			
			var overlap = OverlapSeed.new()
			overlap.start = max(source_start, chunk.source_start)
			overlap.end = min(source_end, chunk.source_end)
			return overlap

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
	var lowest_loc := 1000000000
	var lines := get_input_lines(input_filename)
	var initial_seeds = parse_initial_seeds(lines)
	
	var seeds = []
	for seed_index in range(0, initial_seeds.size(), 2):
		var seed_range = _Range.new()
		seed_range.start = initial_seeds[seed_index]
		var seed_length = initial_seeds[seed_index + 1]
		seed_range.end = seed_range.start + seed_length
		seeds.append(seed_range)
	
	var i := 3
	var maps := []
	while i < lines.size():
		var map := _Map.parse(lines, i)
		map.sort_by_destination()
		maps.append(map)
		i += map.size() + 2
	
	maps.reverse()
	var location = 0
	var found = false
	while not found:
		var map_index = 0
		var seed = location
		while map_index < maps.size():
			var map: _Map = maps[map_index]
			seed = map.translate(seed, true)
			map_index += 1
		
		for seed_range in seeds:
			if seed_range.contains(seed):
				lowest_loc = location
				found = true
				break
		
		location += 1
	
	log_message("Expected sample answer: 46")
	log_message("Expected input answer: < 15290097") # This answer was an off by one error. I tried 15290096 on a whim and got the star.
	return str(lowest_loc)

class _Map:
	var translations: Array = []
	var sorted := false
	var reversed := false
	#
	func get_lowest_destination() -> int:
		var lowest = 2^63-1
		for t: _Translation in translations:
			lowest = min(t.destination_range.start, lowest)
		return lowest
	
	func translate(i: int, reverse: bool) -> int:
		if reversed != reverse:
			sort(reverse)
		
		for translation: _Translation in translations:
			var r: _Range = translation.source_range
			if reverse:
				r = translation.destination_range
				
			if r.contains(i):
				return translation.translate(i, reverse)
			elif r.start > i:
				# We sorted the translations list before starting this loop, so if we've reached a 
				# Range that starts after the number we're looking for, we don't have that number 
				break
		
		# We didn't find a range that included this number, return it unmodified
		return i
		
	func sort_by_destination():
		sort(true)
	
	func sort_by_source():
		sort(false)
	
	func sort(reverse: bool):
		translations.sort_custom(
			func(left: _Translation, right: _Translation):
				if reverse:
					return left.destination_range.start < right.destination_range.start
				
				return left.source_range.start < right.source_range.start
		)
		sorted = true
		reversed = reverse
	
	func size() -> int:
		return translations.size()
	
	static func parse(lines: PackedStringArray, start_index: int) -> _Map:
		var line = lines[start_index]
		var map = _Map.new()
		var i = start_index
		while not line.is_empty() and i < lines.size():
			map.translations.append(_Translation.parse(line))
			
			i += 1
			if i >= lines.size():
				break
			line = lines[i]
		
		return map

class _Translation:
	var source_range: _Range
	var destination_range: _Range
	
	func translate(i: int, reverse: bool) -> int:
		var a: _Range
		var b: _Range
		
		if reverse:
			a = destination_range
			b = source_range
		else:
			a = source_range
			b = destination_range
		
		var operation = b.start - a.start
		
		if a.contains(i):
			return i + operation
		
		if i < 0:
			print("We don't expect i to ever be negative")
		
		return i
	
	static func parse(line: String) -> _Translation:
		var numbers = PackedInt64Array(Array(line.split(" ")))
		var t = _Translation.new()
		t.destination_range = _Range.create(numbers[0], numbers[0] + numbers[2])
		t.source_range = _Range.create(numbers[1], numbers[1] + numbers[2])
		return t

class _Range:
	var start: int
	var end: int
	
	static func create(start: int, end: int) -> _Range:
		var r = _Range.new()
		r.start = start
		r.end = end
		return r
	
	func contains(n: int) -> bool:
		return n <= end and n >= start
	
	func overlaps(r: _Range) -> bool:
		return max(r.start, start) <= min(r.end, end)
		
