extends Node3D

@onready var player=$Player

var rng:RandomNumberGenerator=RandomNumberGenerator.new()

var spawners:Array
var enemy_spawn_chance:Dictionary
var current_wave:int=5
var max_selector:int=25

func _ready() -> void:
	Global.current_map=self
	enemy_spawn_chance={"rat":35, "projectile":62, "hitscan":70, "cloud":95,"rocket":100}
	spawners=[$enemy_spawner,$enemy_spawner2,$enemy_spawner3,$enemy_spawner4]

func _process(_delta: float) -> void:
	if player!=null:
		get_tree().call_group("enemy","update_target_location",player.global_transform.origin)
	print(get_tree().get_node_count_in_group("enemy"))
	if Input.is_action_just_pressed("TEST"):
		spawn_wave()
		#var wave:Array[String]=[]
		##for x in range(0,4):
			##wave.append("rat")
		#for x in range(0,18):
			#wave.append("rat")
		##for x in range(0,4):
			##wave.append("projectile")
		##for x in range(0,4):
			##wave.append("rocket")
		#var wave:Array[String]=generate_wave()
		#$enemy_spawner.spawn_wave(wave)
		#$enemy_spawner2.spawn_wave(wave)
		#$enemy_spawner3.spawn_wave(wave)
		#$enemy_spawner4.spawn_wave(wave)
		#$enemy_spawner.spawn_enemy(preload("res://scenes/enemies/projectile_enemy.tscn"), $enemy_spawner.global_position)

func spawn_wave():
	var new_wave:Array[String]=generate_wave()
	var subwaves:Array=divide_wave(new_wave)
	for i in range(0,spawners.size()):
		var subwave_to_spawn:Array[String]=subwaves[i]
		spawners[i].spawn_wave(subwave_to_spawn)

func generate_wave()->Array[String]:
	var wave:Array[String]
	wave=[]
	var wave_size:int
	if current_wave<=3:
		max_selector=60
		wave_size=12
	elif current_wave<=5:
		max_selector=90
		wave_size=24
	elif current_wave<=7:
		max_selector=95
		wave_size=36
	elif current_wave<=10:
		max_selector=100
		wave_size=48
	elif current_wave<=15:
		max_selector=100
		wave_size=60
	else:
		max_selector=100
		wave_size=72
	
	for i in range(0,wave_size):
		var selector=rng.randi_range(0,max_selector)
		if selector<=enemy_spawn_chance["rat"]:
			wave.append("rat")
		elif selector<=enemy_spawn_chance["projectile"]:
			wave.append("projectile")
		elif selector<=enemy_spawn_chance["hitscan"]:
			wave.append("hitscan")
		elif selector<=enemy_spawn_chance["cloud"]:
			wave.append("cloud")
		else:
			wave.append("rocket")
			
	return wave

func divide_wave(wave:Array[String])->Array:
	var subwave0:Array[String]=[]
	var subwave1:Array[String]=[]
	var subwave2:Array[String]=[]
	var subwave3:Array[String]=[]
	var subwaves:Array=[subwave0,subwave1,subwave2,subwave3]
	var subwave_size:int=wave.size()/4
	for i in range(0,subwaves.size()):
		for j in range(0,subwave_size):
			subwaves[i].append(wave.pop_back())
	return subwaves

#check if player is allowed to build
func _on_building_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.weapon_manager.can_build=true

func _on_building_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.weapon_manager.can_build=false
