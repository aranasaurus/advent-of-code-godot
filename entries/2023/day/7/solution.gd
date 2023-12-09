class_name Day7Solution extends SolutionBase

static var card_map := {
	"2" = 2,
	"3" = 3,
	"4" = 4,
	"5" = 5,
	"6" = 6,
	"7" = 7,
	"8" = 8,
	"9" = 9,
	"T" = 10,
	"J" = 11,
	"Q" = 12,
	"K" = 13,
	"A" = 14
}

func part_1(input_filename: String) -> String:
	var lines := get_input_lines(input_filename)
	var hands: Array[Hand] = []
	
	for line in lines:
		Hand.parse(line).insert_into(hands)
	
	# TODO: The insertion algorithm above should be able to just sort it in reverse
	hands.reverse()
	
	var result := 0
	for i in range(hands.size()):
		result += hands[i].bid * (i + 1)
	
	log_message("Expected Sample: 6440")
	log_message("Expected Input: 251287184")
	return str(result)

func part_2(input_filename: String) -> String:
	var lines := get_input_lines(input_filename)
	var hands: Array[Hand] = []
	Day7Solution.card_map["J"] = 1
	
	for line in lines:
		Hand.parse(line).insert_into(hands)
	
	hands.reverse()
	
	var result := 0
	for i in range(hands.size()):
		result += hands[i].bid * (i + 1)
	
	log_message("Expected Sample: 5905")
	log_message("Expected Input: < 252695264")
	return str(result)

enum HandType {
	FiveOfAKind = 0,
	FourOfAKind = 1,
	FullHouse = 2,
	ThreeOfAKind = 3,
	TwoPair = 4,
	OnePair = 5,
	HighCard = 6
}

class Hand:
	var hand_type: HandType
	var cards: String
	var bid: int
	
	func insert_into(hands: Array[Hand]):
		if hands.is_empty():
			hands.append(self)
			return
		
		hands.insert(insert_position(hands), self)
	
	func insert_position(hands: Array[Hand]) -> int:
		for i in range(hands.size()):
			var other := hands[i]
			if is_greater_than(other):
				return i
			
		return hands.size()
	
	func is_greater_than(other: Hand) -> bool:
		if hand_type < other.hand_type:
			return true
		elif hand_type > other.hand_type:
			return false
			
		for ci in range(cards.length()):
			if Day7Solution.card_map[cards[ci]] > Day7Solution.card_map[other.cards[ci]]:
				return true
			elif Day7Solution.card_map[cards[ci]] < Day7Solution.card_map[other.cards[ci]]:
				return false
		
		return false
	
	static func parse(line: String, j_is_for_joker: bool = false) -> Hand:
		var hand := Hand.new()
		
		hand.bid = int(line.split(" ")[1])
		
		hand.cards = line.split(" ")[0]
		var counts = {}
		for c: String in hand.cards:
			if not counts.has(c):
				counts[c] = 0
			counts[c] += 1
		
		if counts.has("J"):
			var joker_count: int = counts["J"]
			counts["J"] = null
			match counts.keys().size():
				1: # AAAAJ
					hand.hand_type = HandType.FiveOfAKind
				2: # AAKKJ
					if counts.values().has("2") and joker_count == 1:
						hand.hand_type = HandType.FullHouse
					else: # AAAKJ, AKJJJ, AAKJJ
						hand.hand_type = HandType.FourOfAKind
				3: # AKQJJ, AAKQJ 
					hand.hand_type = HandType.ThreeOfAKind
				4: # AKQTJ
					hand.hand_type = HandType.OnePair
		else:
			match counts.keys().size():
				1: hand.hand_type = HandType.FiveOfAKind
				2: 
					if counts.values().has(4):
						hand.hand_type = HandType.FourOfAKind
					else:
						hand.hand_type = HandType.FullHouse
				3: 
					if counts.values().has(3):
						hand.hand_type = HandType.ThreeOfAKind
					else:
						hand.hand_type = HandType.TwoPair
				4: hand.hand_type = HandType.OnePair
				_: hand.hand_type = HandType.HighCard
		
		return hand

