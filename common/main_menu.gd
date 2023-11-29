extends Control

@onready var button_container: VBoxContainer = %ButtonContainer
@onready var back_button: Button = %BackButton

const root_path: String = "res://entries"

func _ready() -> void:
	load_menu(root_path)

func load_menu(path: String) -> void:
	for child in button_container.get_children():
		child.queue_free()
	
	back_button.visible = path != root_path
	
	var directories := DirAccess.get_directories_at(path)
	for dir in directories:
		var button := Button.new()
		button.text = dir
		if path == root_path:
			button.button_up.connect(func(): load_menu("%s/" % root_path + "%s/day" % dir))
		else:
			button.button_up.connect(func():
				load_day(path + "/" + dir)
			)
		button_container.add_child(button)

func load_day(path: String) -> void:
	var file_path := path + "/input.txt"
	if not FileAccess.file_exists(file_path) or FileAccess.get_file_as_string(file_path).length() == 0:
		var req := $HTTPRequest as HTTPRequest
		req.download_file = file_path
		
		var url = path.replace(root_path, "https://adventofcode.com") + "/input"
		var session_path := "res://common/session.txt"
		if not FileAccess.file_exists(session_path):
			print("Session not found in %s" % session_path)
			print("You need to go to adventofcode.com in a browser, log in, and go to an input file (https://adventofcode.com/2022/day/1/input for example) and pull the session from your browser's inspection tab / request headers. Then paste that without the 'session=' into res://common/session.txt. This file is ignored in the .gitignore.")
			return
		
		var cookie = FileAccess.get_file_as_string(session_path).strip_edges()
		req.request(url, ["Cookie: session=%s" % cookie])

	get_tree().change_scene_to_file(path + "/day.tscn")

func _on_back_button_button_up() -> void:
	load_menu(root_path)
