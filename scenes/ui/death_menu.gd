extends Control

func _ready() -> void:
	get_tree().paused=true
	show()
	Input.mouse_mode=Input.MOUSE_MODE_CONFINED
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 1)


func _on_retry_button_pressed() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	get_tree().paused=false
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
	queue_free()
	


func _on_quit_button_pressed() -> void:
	get_tree().paused=false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
