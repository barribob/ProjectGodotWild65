extends Node3D

@onready var reticle = $Reticle
@onready var pivot = $"../RotationalPivot"
@onready var projectile_output = $"../RotationalPivot/Marker3D"
@onready var projectile = load("res://projectile.tscn")

func _process(delta):
    reticle.global_position = Utils.get_3d_mouse_pos(0.1, self, get_viewport().get_camera_3d())
    pivot.look_at(reticle.global_position)
    if Input.is_action_just_pressed("shoot"):
        shoot()

func shoot():
    var b = projectile.instantiate()
    owner.get_parent().add_child(b)
    var params = ProjectileParams.new()
    params.speed = 10
    b.start(params)
    b.transform = projectile_output.global_transform
    b.velocity = -b.transform.basis.z * b.muzzle_velocity
