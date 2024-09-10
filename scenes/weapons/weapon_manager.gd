extends Node3D

var rng=RandomNumberGenerator.new()

@onready var cooldown_timer=$weapon_cooldown_timer
@onready var animation_player=$AnimationPlayer
@onready var audio_player=$AudioStreamPlayer3D
@onready var rays:Array[RayCast3D]=[$rays/center_ray,$rays/top_ray,$rays/bottom_ray,$rays/right_ray,$rays/left_ray]
var sound_no_ammo:AudioStream=preload("res://assets/audio/gun_sfx/no_ammo.ogg")
var sound_weapon_select:AudioStream
var sound_pistol:AudioStream=preload("res://assets/audio/gun_sfx/pistol.ogg")
var sound_shotgun:AudioStream=preload("res://assets/audio/gun_sfx/shotgun.ogg")
var sound_rocket_launcher:AudioStream

var axe
var pistol
var shotgun
var chaingun
var rocket_launcher
var weapons:Array
var weapon_select_animations:Array=["axe_select","pistol_select", "shotgun_select", "chaingun_select", "rocket_launcher_select"]

@export var pistol_damage:int=15
@export var shotgun_damage:int=10
@export var chaingun_damage:int=10
@export var rocket_launcher_damage:int=75

@export var pistol_cooldown:float=.25
@export var shotgun_cooldown:float=.5
@export var chaingun_cooldown:float=.05
@export var rocket_launcher_cooldown:float=1.5
var can_shoot:bool=true

var ammo:Dictionary={"axe":"infinte", "pistol":10, "shotgun":10, "chaingun":100,"rocket_launcher":0}
var current_weapon
var current_weapon_index:int

@export var is_pulling_out_weapon:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	axe=$right_position/axe
	pistol=$right_position/pistol
	shotgun=$right_position/shotgun
	chaingun=$center_position/chaingun
	rocket_launcher=$center_position/rocket_launcher
	weapons=[axe,pistol,shotgun,chaingun,rocket_launcher]
	current_weapon=axe
	current_weapon_index=0
	current_weapon.visible=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_pulling_out_weapon==false:
		shoot()
		select_weapon()

func select_weapon()->void:
	if Input.is_action_just_pressed("select_weapon_1"):
		current_weapon.visible=false
		current_weapon=axe
		current_weapon_index=0
		animation_player.play("axe_select")
		#current_weapon.visible=true
	elif Input.is_action_just_pressed("select_weapon_2"):
		current_weapon.visible=false
		current_weapon=pistol
		current_weapon_index=1
		animation_player.play("pistol_select")
		#current_weapon.visible=true
	elif Input.is_action_just_pressed("select_weapon_3"):
		current_weapon.visible=false
		current_weapon=shotgun
		current_weapon_index=2
		animation_player.play("shotgun_select")
		#current_weapon.visible=true
	elif Input.is_action_just_pressed("select_weapon_4"):
		current_weapon.visible=false
		current_weapon=chaingun
		current_weapon_index=3
		animation_player.play("chaingun_select")
		#current_weapon.visible=true
	elif Input.is_action_just_pressed("select_weapon_5"):
		current_weapon.visible=false
		current_weapon=rocket_launcher
		current_weapon_index=4
		animation_player.play("rocket_launcher_select")
		#current_weapon.visible=true
		
	elif Input.is_action_just_pressed("next_weapon"):
		current_weapon.visible=false
		current_weapon_index=(current_weapon_index+1)%weapons.size()
		current_weapon=weapons[current_weapon_index]
		#current_weapon.visible=true
		animation_player.play(weapon_select_animations[current_weapon_index])
	elif Input.is_action_just_pressed("previous_weapon"):
		current_weapon.visible=false
		current_weapon_index=(current_weapon_index-1)%weapons.size()
		current_weapon=weapons[current_weapon_index]
		#current_weapon.visible=true
		animation_player.play(weapon_select_animations[current_weapon_index])


func shoot()->void:
	#if current_weapon==chaingun:
		#if Input.is_action_pressed():
			#current_weapon.shoot()
	if current_weapon==chaingun:
		if Input.is_action_pressed("shoot"):
			if ammo[current_weapon.name] is not int or ammo[current_weapon.name]>0:
				if can_shoot:
					can_shoot=false
					cooldown_timer.start(chaingun_cooldown)
					play_shot_sound(sound_pistol)
					ammo["chaingun"]-=1
					var ray_index:int=rng.randi_range(0,rays.size()-1)
					print(ray_index)
					if rays[ray_index].is_colliding():
						if rays[ray_index].get_collider().has_method("damage"):
							rays[ray_index].get_collider().damage(chaingun_damage)
			else:
				audio_player.stream=sound_no_ammo
				audio_player.play()
	
	elif Input.is_action_just_pressed("shoot"):
		if ammo[current_weapon.name] is not int or ammo[current_weapon.name]>0:
			if can_shoot:
				if current_weapon==pistol:
					can_shoot=false
					cooldown_timer.start(pistol_cooldown)
					pistol.animation_player.play("shoot")
					play_shot_sound(sound_pistol)
					ammo["pistol"]-=1
					if rays[0].is_colliding():
						if rays[0].get_collider().has_method("damage"):
							rays[0].get_collider().damage(pistol_damage)

				elif current_weapon==shotgun:
					can_shoot=false
					cooldown_timer.start(shotgun_cooldown)
					play_shot_sound(sound_shotgun)
					ammo["shotgun"]-=1
					for i in range(rays.size()):
						if rays[i].is_colliding():
							if rays[i].get_collider().has_method("damage"):
								rays[i].get_collider().damage(shotgun_damage)
					
				#elif current_weapon==chaingun:
					#can_shoot=false
					#cooldown_timer.start(chaingun_cooldown)
					#audio_player.stream=sound_pistol
					#audio_player.play()
					#ammo["chaingun"]-=1
					#var ray_index:int=rng.randi_range(0,rays.size()-1)
					#print(ray_index)
					#if rays[ray_index].is_colliding():
						#if rays[ray_index].get_collider().has_method("damage"):
							#rays[ray_index].get_collider().damage(chaingun_damage)
							
				elif current_weapon==rocket_launcher:
					pass
		else:
			audio_player.stream=sound_no_ammo
			audio_player.play()


func _on_weapon_cooldown_timer_timeout() -> void:
	can_shoot=true

func play_shot_sound(sound:AudioStream):
	audio_player.pitch_scale=1.0+randf_range(-.05,.05)
	audio_player.stream=sound
	audio_player.play()
