extends Area3D

@export var projectile_speed:float=15.0
@onready var timer=$projectile_lifetime_timer
@onready var ray=$RayCast3D
@onready var audio_player=$AudioStreamPlayer3D

var flying:bool=true
var is_exploding:bool=false

func _ready() -> void:
	timer.start()

func _physics_process(delta: float) -> void:
	if flying:
		position+=transform.basis*Vector3(0,0,projectile_speed)*delta
	else:
		explode()

func _on_body_entered(body: Node3D) -> void:
	$Sprite3D.visible=false
	flying=false
	
	if body.has_method("damage"):
		body.damage(100)
	if body.has_method("destroy_block"):
		if ray.is_colliding():
				ray.get_collider().destroy_block(ray.get_collision_point()-ray.get_collision_normal()/2)
	flying=false
	audio_player.play()

func explode()->void:
	var tween=get_tree().create_tween()
	$Area3D.scale
	tween.tween_property($Area3D,"scale",Vector3(12.0,12.0,12.0),0.5)
	#tween.tween_property($Area3D,"modulate",Color(0.804, 0.569, 0.231, 0),.5)

func _on_projectile_lifetime_timer_timeout() -> void:
	queue_free()


func _on_audio_stream_player_3d_finished() -> void:
	queue_free()
