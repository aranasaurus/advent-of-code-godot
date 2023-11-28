extends Button
class_name ExitButton


func _on_button_up() -> void:
	get_tree().quit()
