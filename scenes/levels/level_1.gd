extends Node3D

@onready var player=$Player

func _ready() -> void:
	Global.current_map=self

func _process(_delta: float) -> void:
	if player!=null:
		get_tree().call_group("enemy","update_target_location",player.global_transform.origin)
