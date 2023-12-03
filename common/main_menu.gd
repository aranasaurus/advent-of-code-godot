extends Control
class_name MainMenu

@onready var navigation_buttons: VBoxContainer = %NavigationButtons
@onready var back_button: Button = %BackButton

@onready var day_buttons: VBoxContainer = %DayButtons
@onready var link_button: LinkButton = %LinkButton
@onready var create_sample_button: Button = %CreateSampleButton
@onready var fetch_input_button: Button = %FetchInputButton
@onready var input_choices: OptionButton = %InputChoices
@onready var part_choices: OptionButton = %PartChoices
@onready var copy_answer_button: CheckButton = %CopyAnswerButton

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var log_label: RichTextLabel = %LogLabel
@onready var log_panel: PanelContainer = %LogPanel

const root_path: String = "res://entries"
var path_stack := [root_path]

func _ready() -> void:
	load_navigation_menu(root_path)

func navigate_to(path: String) -> void:
	path_stack.push_front(path)
	load_navigation_menu(path)

func navigate_back() -> void:
	path_stack.pop_front()
	
	load_navigation_menu(root_path if path_stack.is_empty() else path_stack.front())

func load_navigation_menu(path: String) -> void:
	for child in navigation_buttons.get_children():
		child.queue_free()
	
	navigation_buttons.visible = true
	day_buttons.visible = false
	back_button.visible = path != root_path
	
	var directories := DirAccess.get_directories_at(path)
	for dir in directories:
		var button := Button.new()
		button.text = dir
		if path == root_path:
			var year_day_path = root_path + "/%s/day" % dir
			var day_dirs = DirAccess.get_directories_at(year_day_path)
			for day_dir in day_dirs:
				var day_path = year_day_path + "/" + day_dir
				if day_has_solution_scene(day_path):
					button.button_up.connect(func(): 
						path_stack.push_front(year_day_path)
						load_navigation_menu(year_day_path)
					)
					navigation_buttons.add_child(button)
					break
		else:
			var day_path = path + "/" + dir
			if day_has_solution_scene(day_path):
				button.button_up.connect(func():
					load_day(day_path)
				)
				navigation_buttons.add_child(button)

func day_has_solution_scene(day_path: String) -> bool:
	return DirAccess.get_files_at(day_path).find("solution.tscn") >= 0

func load_day(path: String):
	if path != path_stack.front():
		path_stack.push_front(path)
	
	input_choices.clear()
	
	navigation_buttons.visible = false
	day_buttons.visible = true
	back_button.visible = true
	
	link_button.uri = url_for_day_path(path)
	link_button.text = path.replace(root_path, "").lstrip("/")
	
	create_sample_button.visible = not FileAccess.file_exists(path + "/sample.txt")
	fetch_input_button.visible = not FileAccess.file_exists(path + "/input.txt")
	
	var files := DirAccess.get_files_at(path)
	for file in files:
		if file.get_extension() == "txt":
			input_choices.add_item(file.get_file())

func url_for_day_path(path: String = path_stack.front()) -> String:
	return path.replace(root_path, "https://adventofcode.com")

func log_message(message: String) -> void:
	log_panel.visible = true
	log_label.text += "\n" + message
	# print(message)

func _on_back_button_button_up() -> void:
	navigate_back()

func _on_get_input_button_button_up() -> void:
	var path: String = path_stack.front()
	var file_path := path + "/input.txt"
	
	http_request.download_file = file_path
	
	var url = url_for_day_path(path) + "/input"
	var session_path := "res://common/session.txt"
	if not FileAccess.file_exists(session_path):
		log_message("Session not found in %s" % session_path)
		log_message("Opening %s in your browser so you can pull the cookie/session from your inspection tab / request headers. Paste the session value (just the value, no 'session=' or 'session: ') into res://common/session.txt. Don't worry, that file is ignored in the .gitignore." % url)
		OS.shell_open(url)
		return
	
	var cookie := "Cookie: session=%s" % FileAccess.get_file_as_string(session_path).strip_edges()
	log_message("Downloading input.txt from " + url + " using cookie '%s'" % cookie)
	http_request.request(url, [cookie])

func _on_http_request_request_completed(result: int, _response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	# TODO: Make a Toast system of some kind and show these messages (or something similar) in the UI
	log_message("Request completed")
	if result == HTTPRequest.RESULT_SUCCESS:
		log_message("Successfully downloaded %d bytes" % http_request.get_downloaded_bytes())
		load_day(path_stack.front())
	else:
		log_message("Download failed: %d" % result)
		log_message("Opening the input file in a browser instead.")
		OS.shell_open(url_for_day_path() + "/input")

func _on_create_sample_button_button_up() -> void:
	var file := FileAccess.open(path_stack.front() + "/sample.txt", FileAccess.WRITE)
	file.store_string(DisplayServer.clipboard_get())
	file.close()
	
	load_day(path_stack.front())

func _on_run_button_button_up() -> void:
	var solution := load(path_stack.front() + "/solution.tscn").instantiate() as SolutionBase
	var input = input_choices.get_item_text(input_choices.selected)
	
	log_message("Running...")
	var answer: String
	if part_choices.selected == 0:
		answer = solution.part_1(input)
	else:
		answer = solution.part_2(input)
	
	log_message("Answer: " + answer)
	if copy_answer_button.button_pressed:
		DisplayServer.clipboard_set(answer)
		log_message("Copied to your clipboard")
