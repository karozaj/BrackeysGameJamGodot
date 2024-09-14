extends Node3D

@onready var player=$Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.current_map=self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player!=null:
		get_tree().call_group("enemy","update_target_location",player.global_transform.origin)
	if Input.is_action_just_pressed("TEST"):
		player.weapon_manager.select_block_weapon()
		var enemy=preload("res://scenes/enemies/cloud_enemy.tscn")
		var enemy_Scene=enemy.instantiate()
		add_child(enemy_Scene)
			
