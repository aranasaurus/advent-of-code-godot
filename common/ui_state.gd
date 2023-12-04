class_name UIState extends Resource

@export var save_path := "user://ui_state.tres"
@export var root_ui_path: String = "res://entries"
@export var path_stack := [root_ui_path]
@export var copy_answer_to_clipboard_enabled := true:
	set(new_value):
		copy_answer_to_clipboard_enabled = new_value
		save()
@export var selected_part := 0:
	set(new_value):
		selected_part = new_value
		save()
@export var selected_input_filename := "sample.txt":
	set(new_value):
		selected_input_filename = new_value
		save()

var day_path_regex: RegEx

static func load_or_create(from_save_path: String = "user://ui_state.tres") -> UIState:
	var state: UIState
	if FileAccess.file_exists(from_save_path):
		state = load(from_save_path) as UIState
	else:
		state = UIState.new()
	return state

func _init() -> void:
	day_path_regex = RegEx.new()
	day_path_regex.compile(r".*\/day\/\d")
	
func save() -> void:
	ResourceSaver.save(self, save_path)

func push_path(path: String) -> void:
	path_stack.push_front(path)
	save()

func pop_path() -> String:
	var path = path_stack.pop_front()
	save()
	return path

func current_path() -> String:
	if path_stack.is_empty():
		return root_ui_path
	return path_stack.front()

func is_current_path_day() -> bool:
	return not day_path_regex.search_all(current_path()).is_empty()
