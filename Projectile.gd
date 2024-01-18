extends Node3D

var speed = 0

var damage
var velocity = Vector3.ZERO
var muzzle_velocity = 25

func start(projectile_params):
    speed = projectile_params.speed
    damage = projectile_params.damage

func _physics_process(delta):
    look_at(transform.origin + velocity.normalized(), Vector3.UP)
    transform.origin += velocity * delta

func _on_area_3d_area_entered(area):
    if area.has_method("damage"):
        area.damage({damage = damage})
    queue_free()
