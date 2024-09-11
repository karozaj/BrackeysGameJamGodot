extends CharacterBody3D

const SENSITIVITY=0.004
const SPEED = 5.0
const SPRINT_SPEED=7.5
const JUMP_VELOCITY = 4.5

var speed:float=SPEED
var movement_lerp_val:float=0.15

var health:int=100
var is_dead:bool=false

@onready var camera:Camera3D=$Pivot/Camera3D
@onready var gun_camera:Camera3D=$Pivot/GunCamera3D
@onready var pivot:Node3D=$Pivot
@onready var raycast:RayCast3D=$Pivot/Camera3D/RayCast3D
@onready var weapon_manager=$Pivot/GunCamera3D/WeaponManager
@onready var footstep_audio_player=$footstep_audio_player

func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	RenderingServer.viewport_attach_camera($CanvasLayer/SubViewportContainer/SubViewport.get_viewport_rid(),gun_camera.get_camera_rid())
	

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		pivot.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		gun_camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		gun_camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

	
	if Input.is_action_just_pressed('exit'):
		get_tree().quit()
		


func _physics_process(delta):
	if Input.is_action_pressed("sprint"):
		speed=SPRINT_SPEED
	else:
		speed=SPEED
	
	if is_on_floor() and abs(Vector2(velocity.x,velocity.z).length())>=2.0:
		if footstep_audio_player.playing==false:
			footstep_audio_player.play()
	else:
		footstep_audio_player.stop()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
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
	
func damage(damage_points:int):
	health-=damage_points
	if health<=0:
		die()
		
func die():
	is_dead=true
