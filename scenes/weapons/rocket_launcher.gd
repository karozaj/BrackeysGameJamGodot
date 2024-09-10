extends Node3D

@onready var animation_player:AnimationPlayer=$AnimationPlayer
@onready var audio_player:AudioStreamPlayer3D=$AudioStreamPlayer3D
@onready var muzzle_flash:Sprite3D=$Cube_001/tip/muzzle_flash
var default_pitch:float=0.2

var projectile_scene=load("res://scenes/weapons/rocket_projectile.tscn")
var projectile

var rng=RandomNumberGenerator.new()
var cooldown:float=1.0
var base_damage:int=75

func shoot():
	animation_player.play("shoot")
	projectile=projectile_scene.instantiate()
	projectile.position=$Cube_001/tip.global_position
	projectile.transform.basis=$RayCast3D.global_transform.basis
	if Global.current_map!=null:
		Global.current_map.add_child(projectile)
	#get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().add_child(projectile_instance)

func play_shooting_sound():
	audio_player.pitch_scale=default_pitch+rng.randf_range(-.1,.05)
	audio_player.play()

func muzzle_flash_flip():
	var flip_index:int=rng.randi_range(0,1)
	if flip_index==0:
		muzzle_flash.flip_h=!muzzle_flash.flip_h
	else:
		muzzle_flash.flip_v=!muzzle_flash.flip_v
