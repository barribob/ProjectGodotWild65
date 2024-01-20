extends CharacterBody3D

signal gain_exp(amt)
signal player_damaged(damage_params)

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var model = $Model
@onready var reticle = $ShootHandler/Reticle
@onready var level_up_particle_scene = load("res://level_up_particles.tscn")
@onready var mesh: MeshInstance3D = $Model/RotationFix/PlayerRobot/metarig/Skeleton3D/Cube
@onready var damaged_audio = load("res://sounds/Player_Damage_Hit_SFX_v1.wav")

const base_pick_up_range = 2.5
const base_speed = 5.0

var pick_up_range = base_pick_up_range
var slowdown_while_shooting = 0.4
var is_frozen = false
var slowdown_time = 0.3
var slowdown_cooldown = 0.0
var move_speed = base_speed
var transition_speed = 0.5
var move_lag : float = 16.0
var turn_lag : float = 16.0

var current_input: Vector2
var current_velocity: Vector2

func _ready():
    Console.add_command("sfx", func(): SoundManager.play_sound(damaged_audio))
    EventBus.win_game.connect(_on_timer_label_win_game)

func _process(delta):
    slowdown_cooldown = clampf(slowdown_cooldown - delta, 0, slowdown_time)

    var xz_velocity = Vector3(velocity.x, 0, velocity.z)
    var walk_dir = xz_velocity * model.basis
    animation_tree.set("parameters/Locomotion/Locomotion/blend_position", Vector2(walk_dir.x, -walk_dir.z))

    if (reticle.global_position - model.global_position).length() > 0.5:
        var target_position = reticle.global_position
        var new_transform = model.global_transform.looking_at(target_position, Vector3.UP)
        model.global_transform = model.global_transform.interpolate_with(new_transform, turn_lag * delta)

func _physics_process(delta):
    var slowed_down = slowdown_cooldown > 0
    var speed = slowdown_while_shooting * move_speed if slowed_down else move_speed

    current_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var direction = (transform.basis * Vector3(current_input.x, 0, current_input.y)).normalized()
    if direction and not is_frozen:
        velocity = lerp(velocity, direction * speed, delta * move_lag)
    else:
        velocity = lerp(velocity, Vector3.ZERO, delta * move_lag)

    move_and_slide()

var is_invincible
var invincibility_time = 0.5

func _on_damageable_damaged(damage_params):
    if is_invincible:
        return

    flash()
    SoundManager.play_sound(damaged_audio)
    player_damaged.emit(damage_params)
    is_invincible = true
    var tween = create_tween()
    tween.tween_callback(func(): is_invincible = false).set_delay(invincibility_time)

func flash():
    var tween = create_tween()
    tween.tween_method(set_flash, 1.0, 0, 0.2 * Engine.time_scale)

func set_flash(f):
    var material = mesh.material_overlay as ShaderMaterial
    material.set_shader_parameter("flash_lerp", f)

func _on_shoot_handler_fired():
    slowdown_cooldown = slowdown_time

func _on_item_detection_picked(params):
    gain_exp.emit(1)

func _on_hud_leveled():
    var level_up_particles = level_up_particle_scene.instantiate()
    add_child(level_up_particles)

func _on_health_died():
    is_frozen = true
    hide()

func _on_timer_label_win_game():
    is_frozen = true
