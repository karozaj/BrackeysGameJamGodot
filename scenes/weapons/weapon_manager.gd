extends Node3D

var rng=RandomNumberGenerator.new()

@onready var cooldown_timer:Timer=$weapon_cooldown_timer
@onready var animation_player:AnimationPlayer=$AnimationPlayer
@onready var audio_player:AudioStreamPlayer3D=$AudioStreamPlayer3D
@onready var ray_position:Marker3D=$ray_position

var sound_no_ammo:AudioStream=preload("res://assets/audio/gun_sfx/no_ammo.ogg")
var sound_weapon_select:AudioStream

var block
var axe
var pistol
var shotgun
var chaingun
var rocket_launcher
var weapons:Array
var weapon_select_animations:Array=["axe_select","pistol_select", "shotgun_select", "chaingun_select", "rocket_launcher_select"]
var is_block_mode_active:bool=false
var can_shoot:bool=true
var ammo:Dictionary={"axe":"infinte", "pistol":10, "shotgun":10, "chaingun":100,"rocket_launcher":10}
var current_weapon
var current_weapon_index:int
var is_pulling_out_weapon:bool=false

func _ready() -> void:
	is_pulling_out_weapon=false
	can_shoot=true
	axe=$right_position/axe
	pistol=$right_position/pistol
	shotgun=$right_position/shotgun
	chaingun=$center_position/chaingun
	rocket_launcher=$center_position/rocket_launcher
	weapons=[axe,pistol,shotgun,chaingun,rocket_launcher]
	for weapon in weapons:
		if weapon.has_method("allign_rays"):
			weapon.allign_rays(ray_position.global_position)
	
	reset_weapon_selection()
	
func _process(_delta: float) -> void:
	handle_shooting()
	if is_block_mode_active==false:
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

func shoot_weapon()->void:
	current_weapon.shoot()
	if ammo[current_weapon.name] is int:
		ammo[current_weapon.name]-=1
	can_shoot=false
	cooldown_timer.start(current_weapon.cooldown)

func has_ammo(weapon_name:String)->bool:
	if ammo[weapon_name] is not int or ammo[weapon_name]>0:
		return true
	return false

func _on_weapon_cooldown_timer_timeout() -> void:
	can_shoot=true

func handle_shooting()->void:
	if is_pulling_out_weapon==false:
		if current_weapon==chaingun:
			if Input.is_action_pressed("shoot") and can_shoot:
				if has_ammo(current_weapon.name):
					shoot_weapon()
				else:
					audio_player.stream=sound_no_ammo
					audio_player.play()
		else:
			if Input.is_action_just_pressed("shoot") and can_shoot:
				if has_ammo(current_weapon.name):
					shoot_weapon()
				else:
					audio_player.stream=sound_no_ammo
					audio_player.play()
	
func select_block_weapon()->void:
	current_weapon=block
	current_weapon_index=-1
	is_block_mode_active=true

func reset_weapon_selection()->void:
	current_weapon=axe
	current_weapon_index=0
	current_weapon.visible=true
