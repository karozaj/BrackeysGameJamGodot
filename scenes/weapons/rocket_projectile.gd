extends Area3D

@export var projectile_speed:float=15.0
@onready var timer=$projectile_lifetime_timer
@onready var ray=$RayCast3D

func _ready() -> void:
	timer.start()

func _physics_process(delta: float) -> void:
	position+=transform.basis*Vector3(0,0,projectile_speed)*delta


func _on_body_entered(body: Node3D) -> void:
	if body.has_method("damage"):
		body.damage(100)
	if body.has_method("destroy_block"):
		if ray.is_colliding():
				ray.get_collider().destroy_block(ray.get_collision_point()-ray.get_collision_normal()/2)
	queue_free()

func explode()->void:
	pass

func _on_projectile_lifetime_timer_timeout() -> void:
	queue_free()
