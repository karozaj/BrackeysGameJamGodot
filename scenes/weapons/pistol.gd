extends Node3D

@onready var animation_player=$AnimationPlayer
var sound_pistol:AudioStream=preload("res://assets/audio/gun_sfx/pistol.ogg")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shoot():
	pass
