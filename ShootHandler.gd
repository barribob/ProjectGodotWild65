extends Node3D

signal fired
signal reload_start(cooldown)
signal reload_cancel

@onready var reticle = $Reticle
@onready var pivot = $"../RotationalPivot"
@onready var projectile_output = $"../RotationalPivot/Marker3D"
@onready var projectile = load("res://projectile.tscn")
@onready var animation_tree = %AnimationTree

const base_shoot_interval = 0.3
const base_clip_size = 5
const base_reload_time = 1.5
const base_damage = 1

var shoot_interval = base_shoot_interval
var shoot_cooldown = 0.0
var _clip_size: int
var clip_size: int:
    get:
        return _clip_size
    set(value):
        _clip_size = value
        EventBus.ammo_updated.emit(current_ammo, value)

var _current_ammo: int
var current_ammo: int:
    get:
        return _current_ammo
    set(value):
        _current_ammo = value
        EventBus.ammo_updated.emit(value, clip_size)

var reload_time = base_reload_time
var reload_cooldown = 0.0
var is_reloading = false
var shoot_button_down = false
var time_idle_to_auto_reload = 0.3
var idle_time = 0.0
var damage = base_damage
var shot_counter = 0
var upper_body_animation: AnimationNodeStateMachinePlayback

func _ready():
    upper_body_animation = animation_tree.get("parameters/UpperBodyStateMachine/playback")
    animation_tree.set("parameters/UpperBodyBlend/blend_amount", 0.0)
    await get_tree().create_timer(0.1).timeout
    clip_size = base_clip_size
    current_ammo = base_clip_size

func _process(delta):
    reticle.global_position = Utils.get_3d_mouse_pos(0.1, self, get_viewport().get_camera_3d())
    pivot.look_at(reticle.global_position)

    if is_reloading:
        reload_cooldown = clampf(reload_cooldown - delta, 0, reload_time)
        if Utils.leq(reload_cooldown, 0):
            current_ammo = clip_size
            is_reloading = false

    shoot_cooldown = clampf(shoot_cooldown - delta, 0, shoot_interval)

    if !shoot_button_down:
        idle_time += delta
    else:
        idle_time = 0

    if shoot_button_down and Utils.leq(shoot_cooldown, 0) and current_ammo > 0:
        animation_tree.set("parameters/UpperBodyBlend/blend_amount", 0.95)
        upper_body_animation.start("shoot")
        shoot()
        shot_counter += 1
        fired.emit()
        shoot_cooldown = shoot_interval
        current_ammo -= 1
        is_reloading = false
        reload_cancel.emit()
        reload_cooldown = 0 # cancel any in-progress reloads
        if current_ammo == 0:
            reload_cooldown = reload_time
            is_reloading = true
            reload_start.emit(reload_time)
    elif not is_reloading and current_ammo < clip_size and Utils.geq(idle_time, time_idle_to_auto_reload):
        upper_body_animation.travel("idle")
        reload_cooldown = reload_time
        is_reloading = true
        reload_start.emit(reload_time)

func _unhandled_input(event):
    if event is InputEventMouseButton and event.is_action("shoot"):
        shoot_button_down = event.is_pressed()
        if !shoot_button_down:
            animation_tree.set("parameters/UpperBodyBlend/blend_amount", 0.0)

func create_projectile():
    var b = projectile.instantiate()
    owner.get_parent().add_child(b)
    var params = { speed = 10, damage = damage }
    b.start(params)
    return b

func get_aim_dir():
    var direction = (reticle.global_position - projectile_output.global_position)
    var dir_xy = Vector3(direction.x, 0, direction.z).normalized()
    return dir_xy

func shoot():
    var b = create_projectile()
    var dir_xy = get_aim_dir()
    b.transform = projectile_output.global_transform
    b.velocity = dir_xy * b.muzzle_velocity

func shoot_in_fan():
    var min_angle = -45
    var angle_between = 30
    for i in 4:
        var b = create_projectile()
        var dir_xy = get_aim_dir()
        var dir_rotated = dir_xy.rotated(Vector3.UP, deg_to_rad(i * angle_between + min_angle))
        b.transform = projectile_output.global_transform
        b.velocity = dir_rotated * b.muzzle_velocity
