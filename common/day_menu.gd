extends PanelContainer
class_name DayMenu

@onready var run_button: Button = %RunButton
@onready var input_choices: OptionButton = %InputChoices

func _ready() -> void:
	input_choices.clear()
	
	var path := get_tree().current_scene.scene_file_path.get_base_dir()
	var files := DirAccess.get_files_at(path)
	for file in files:
		if file.get_extension() == "txt":
			input_choices.add_item(file.get_file())

func _on_back_button_button_up() -> void:
	get_tree().change_scene_to_file("res://common/main_menu.tscn")
