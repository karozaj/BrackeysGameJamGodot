extends Control

func _ready() -> void:
	get_tree().paused=true
	show()
	Input.mouse_mode=Input.MOUSE_MODE_CONFINED
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
