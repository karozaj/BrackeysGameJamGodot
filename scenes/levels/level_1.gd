extends Node3D

@onready var player=$Player

func _ready() -> void:
	Global.current_map=self

func _process(_delta: float) -> void:
	if player!=null:
		get_tree().call_group("enemy","update_target_location",player.global_transform.origin)

	if Input.is_action_just_pressed("TEST"):
		var wave:Array[String]=[]
		#for x in range(0,4):
			#wave.append("rat")
		for x in range(0,18):
			wave.append("cloud")
		#for x in range(0,4):
			#wave.append("projectile")
		#for x in range(0,4):
			#wave.append("rocket")
		$enemy_spawner.spawn_wave(wave)
		#$enemy_spawner.spawn_enemy(preload("res://scenes/enemies/projectile_enemy.tscn"), $enemy_spawner.global_position)

func _on_building_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.weapon_manager.can_build=true

func _on_building_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.weapon_manager.can_build=false
