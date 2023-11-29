extends PanelContainer
class_name DayMenu

@onready var run_button: Button = %RunButton
@onready var input_choices: OptionButton = %InputChoices
@onready var get_input_button: Button = %GetInputButton
@onready var http_request: HTTPRequest = $HTTPRequest

func _ready() -> void:
	load_menu()

func load_menu():
	input_choices.clear()
	
	var path := get_tree().current_scene.scene_file_path.get_base_dir()
	var files := DirAccess.get_files_at(path)
	for file in files:
		if file.get_extension() == "txt":
			input_choices.add_item(file.get_file())

func _on_back_button_button_up() -> void:
	get_tree().change_scene_to_file("res://common/main_menu.tscn")

func _on_get_input_button_button_up() -> void:
	var path := get_tree().current_scene.scene_file_path.get_base_dir()
	var file_path := path + "/input.txt"
	
	http_request.download_file = file_path
	
	var url = path.replace(MainMenu.root_path, "https://adventofcode.com") + "/input"
	var session_path := "res://common/session.txt"
	if not FileAccess.file_exists(session_path):
		print("Session not found in %s" % session_path)
		print("You need to go to adventofcode.com in a browser, log in, and go to an input file (https://adventofcode.com/2022/day/1/input for example) and pull the session from your browser's inspection tab / request headers. Then paste that without the 'session=' into res://common/session.txt. This file is ignored in the .gitignore.")
		return
	
	var cookie := "Cookie: session=%s" % FileAccess.get_file_as_string(session_path).strip_edges()
	print("Downloading input.txt from " + url + " using cookie '%s'" % cookie)
	http_request.request(url, [cookie])


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	# TODO: Make a Toast system of some kind and show these messages (or something similar) in the UI
	print("Request completed")
	if result == HTTPRequest.RESULT_SUCCESS:
		print("Successfully downloaded %d bytes" % http_request.get_downloaded_bytes())
		load_menu()
	else:
		print("Download failed: %d" % result)
