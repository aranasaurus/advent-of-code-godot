extends SolutionBase

var word_digit_map := {
	"one": "1",
	"two": "2",
	"three": "3",
	"four": "4",
	"five": "5",
	"six": "6",
	"seven": "7",
	"eight": "8",
	"nine": "9"
}

func part_1(input_filename: String) -> String:
	var number_lines := get_number_lines(input_filename)
	
	var numbers := []
	for line: Array in number_lines:
		numbers.append(line.front() + line.back())
	print(numbers)
	
	var sum: int = numbers.reduce(convert_to_int_and_sum, 0)
	return str(sum)

func part_2(input_filename: String) -> String:
	var number_lines := get_number_lines(input_filename, true).filter(func(line): return not line.is_empty())
	print(number_lines)
	var numbers := []
	for line: Array in number_lines:
		numbers.append(line.front() + line.back())
	print(numbers)
	
	var sum: int = numbers.reduce(convert_to_int_and_sum, 0)
	return str(sum)

func get_number_lines(input_filename: String, replace_words: bool = false) -> Array:
	var lines := get_input_lines(input_filename)
	var number_lines = Array(lines).map(func(line: String):
		var numbers := []
		if replace_words:
			var inserts := {}
			for key in word_digit_map:
				var i = line.find(key)
				while i >= 0:
					inserts[i] = word_digit_map[key]
					i = line.find(key, i + 1)
			
			var sorted_inserts = inserts.keys()
			sorted_inserts.sort()
			for i in sorted_inserts.size():
				var original_location = sorted_inserts[i]
				line = line.insert(original_location + i, inserts[original_location])
		
		for c in line:
			if c.is_valid_int():
				numbers.append(c)
		return numbers
	)
	return number_lines

func convert_to_int_and_sum(sum: int, n: String) -> int:
	return sum + int(n)
