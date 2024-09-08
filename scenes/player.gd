extends CharacterBody3D

const SENSITIVITY=0.004
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var speed:float=SPEED
var movement_lerp_val:float=0.15

var health:int=100
var is_dead:bool=false

@onready var camera:Camera3D=$Pivot/Camera3D
@onready var pivot:Node3D=$Pivot
@onready var raycast:RayCast3D=$Pivot/Camera3D/RayCast3D

func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		pivot.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
		if raycast.is_colliding():
			if raycast.get_collider().has_method("destroy_block"):
				print(raycast.get_collision_normal())
				raycast.get_collider().destroy_block(raycast.get_collision_point()-raycast.get_collision_normal()/2)

	
	if Input.is_action_just_pressed("place_block"):
		if raycast.is_colliding():
			if raycast.get_collider().has_method("place_block"):
				raycast.get_collider().place_block(raycast.get_collision_point()+raycast.get_collision_normal()/2)
	
	if Input.is_action_just_pressed('exit'):
		get_tree().quit()
		


func _physics_process(delta):
	
	if raycast.is_colliding():
		if raycast.get_collider().has_method("highlight"):
			raycast.get_collider().highlight(raycast.get_collision_point()+raycast.get_collision_normal())
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction=direction.rotated(Vector3.UP, pivot.rotation.y)

	if direction:
		velocity.x = lerp(velocity.x,direction.x * speed,movement_lerp_val)
		velocity.z = lerp(velocity.z,direction.z * speed,movement_lerp_val)
	else :
		velocity.x = lerp(velocity.x,0.0,movement_lerp_val)
		velocity.z = lerp(velocity.z,0.0,movement_lerp_val)

	move_and_slide()
	
func shoot():
	pass
	
func damage(damage_points:int):
	health-=damage_points
	if health<=0:
		die()
		
func die():
	is_dead=true
