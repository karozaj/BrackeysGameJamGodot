extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var health:int=100
var is_dead:bool=false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var player:CharacterBody3D=get_tree().get_first_node_in_group("player")
@onready var nav_agent:NavigationAgent3D=$NavigationAgent3D

func _ready() -> void:
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if player==null or is_dead:
		return
		
	var current_location=global_transform.origin
	var next_location=nav_agent.get_next_path_position()
	var new_velocity=(next_location-current_location).normalized()*SPEED
	velocity.x=velocity.move_toward(new_velocity,0.25).x
	velocity.z=velocity.move_toward(new_velocity,0.25).z
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var looking_direction=Vector3(player.global_position.x,global_position.y,player.global_position.z)
	look_at(looking_direction)
	
	if $RayCast3D.is_colliding() and is_on_floor():
		jump()
	
	move_and_slide()

func update_target_location(target_location):
	nav_agent.target_position=target_location

func jump():
	velocity.y+=5.0
	
func damage(damage_points:int):
	print(damage_points)
	health-=damage_points
	if health<=0:
		is_dead=true
		queue_free()
	
