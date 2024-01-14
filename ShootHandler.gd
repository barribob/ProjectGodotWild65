extends Node3D

@onready var reticle = $Reticle
@onready var pivot = $"../RotationalPivot"
@onready var projectile_output = $"../RotationalPivot/Marker3D"
@onready var projectile = load("res://projectile.tscn")

var shoot_interval = 0.5
var shoot_cooldown = 0.0

func _process(delta):
    reticle.global_position = Utils.get_3d_mouse_pos(0.1, self, get_viewport().get_camera_3d())
    pivot.look_at(reticle.global_position)
    
    shoot_cooldown = clampf(shoot_cooldown - delta, 0, shoot_interval)
    if Input.is_action_pressed("shoot") and Utils.leq(shoot_cooldown, 0):
        shoot()
        shoot_cooldown = shoot_interval

func shoot():
    var b = projectile.instantiate()
    owner.get_parent().add_child(b)
    var params = ProjectileParams.new()
    params.speed = 10
    b.start(params)
    b.transform = projectile_output.global_transform
    b.velocity = -b.transform.basis.z * b.muzzle_velocity
