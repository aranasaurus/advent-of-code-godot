extends Control
class_name MainMenu

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
	get_tree().change_scene_to_file(path + "/day.tscn")

func _on_back_button_button_up() -> void:
	load_menu(root_path)
