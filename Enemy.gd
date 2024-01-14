extends CharacterBody3D

var player
var speed = 1.0

func _physics_process(delta):
    if player:
        look_at(player.global_position, Vector3.UP)
        transform.origin += -transform.basis.z * speed * delta

func init(in_player):
    player = in_player

func damage(damage_params):
    queue_free()
