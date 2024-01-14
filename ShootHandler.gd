extends Node3D

@onready var reticle = $Reticle
@onready var pivot = $"../RotationalPivot"
@onready var projectile_output = $"../RotationalPivot/Marker3D"
@onready var projectile = load("res://projectile.tscn")

var shoot_interval = 0.3
var shoot_cooldown = 0.0
var clip_size = 5
var current_ammo: int = 5
var reload_time = 1.0
var reload_cooldown = 0.0

func _process(delta):
    reticle.global_position = Utils.get_3d_mouse_pos(0.1, self, get_viewport().get_camera_3d())
    pivot.look_at(reticle.global_position)
    
    if current_ammo == 0:
        reload_cooldown = clampf(reload_cooldown - delta, 0, reload_time)
        if Utils.leq(reload_cooldown, 0):
            current_ammo = clip_size
    
    shoot_cooldown = clampf(shoot_cooldown - delta, 0, shoot_interval)
    if Input.is_action_pressed("shoot") and Utils.leq(shoot_cooldown, 0) and current_ammo > 0:
        shoot()
        shoot_cooldown = shoot_interval
        current_ammo -= 1
        if current_ammo == 0:
            reload_cooldown = reload_time

func shoot():
    var b = projectile.instantiate()
    owner.get_parent().add_child(b)
    var params = ProjectileParams.new()
    params.speed = 10
    b.start(params)
    b.transform = projectile_output.global_transform
    b.velocity = -b.transform.basis.z * b.muzzle_velocity
