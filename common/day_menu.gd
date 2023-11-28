extends PanelContainer
class_name DayMenu

@onready var run_button: Button = %RunButton
@onready var input_choices: OptionButton = %InputChoices

func _ready() -> void:
	input_choices.clear()
	
	var path := get_tree().current_scene.scene_file_path.get_base_dir()
	var dir_iterator := DirAccess.open(path)
	if dir_iterator:
		dir_iterator.list_dir_begin()
		var file := dir_iterator.get_next()
		while file != "":
			if file.get_extension() == "txt":
				input_choices.add_item(file.get_file())
			
			file = dir_iterator.get_next()
	else:
		print("An error occurred when trying to load menu for %s" % path)

func _on_back_button_button_up() -> void:
	get_tree().change_scene_to_file("res://common/main_menu.tscn")
