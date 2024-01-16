extends Node3D

var player: Node3D
var velocity: Vector3
var speed = 1.0
var move_lag : float = 16.0

func start(in_player):
    player = in_player
    
func _physics_process(delta):
    if player.global_position.distance_squared_to(global_position) < 10:
        look_at(player.global_position, Vector3.UP)
        velocity = lerp(velocity, -transform.basis.z * speed, delta * move_lag)
        global_position += velocity

func _on_area_3d_area_entered(area):
    if area.has_method("pick"):
        area.pick({})
    queue_free()
