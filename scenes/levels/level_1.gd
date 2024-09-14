extends Node3D

@onready var player=$Player
var rat_enemy_scene=preload("res://scenes/enemies/rat_enemy.tscn")
var hitscan_enemy_scene=preload("res://scenes/enemies/hitscan_enemy.tscn")
var projectile_enemy_scene=preload("res://scenes/enemies/projectile_enemy.tscn")
var cloud_enemy_scen=preload("res://scenes/enemies/cloud_enemy.tscn")
var rocket_enemy_scene=preload("res://scenes/enemies/rocket_enemy.tscn")

func _ready() -> void:
	Global.current_map=self

func _process(_delta: float) -> void:
	if player!=null:
		get_tree().call_group("enemy","update_target_location",player.global_transform.origin)


func _on_building_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.weapon_manager.can_build=true

func _on_building_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.weapon_manager.can_build=false
