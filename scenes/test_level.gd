extends Node3D

@onready var player=$Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.current_map=self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player!=null:
		get_tree().call_group("enemy","update_target_location",player.global_transform.origin)
