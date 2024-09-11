extends Control

func _ready() -> void:
	$VBoxContainer/GridContainer/VBoxContainer/SoundSlider.value=Global.get_volume("SFX")
	$VBoxContainer/GridContainer/VBoxContainer2/MusicSlider.value=Global.get_volume("Music")
	$VBoxContainer/FullscreenButton.button_pressed=Global.is_fullscreen()
	get_tree().paused=true
	show()
	Input.mouse_mode=Input.MOUSE_MODE_CONFINED

func _on_sound_slider_value_changed(value):
	Global.update_bus_volume("SFX",value)

func _on_music_slider_value_changed(value):
	Global.update_bus_volume("Music",value)

func _on_resume_button_pressed():
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	get_tree().paused=false
	queue_free()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_fullscreen_button_toggled(button_pressed):
	if button_pressed==true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
	if button_pressed==false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
