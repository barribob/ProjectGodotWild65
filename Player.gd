extends CharacterBody3D

signal gain_exp(amt)
signal player_damaged(damage_params)

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var model = $Model
@onready var reticle = $ShootHandler/Reticle

var speed_while_shooting = 2.0
var slowdown_time = 0.3
var slowdown_cooldown = 0.0
var regular_speed = 5.0
var transition_speed = 0.5
var move_lag : float = 16.0

var current_input: Vector2
var current_velocity: Vector2

func _process(delta):
    slowdown_cooldown = clampf(slowdown_cooldown - delta, 0, slowdown_time)
    
    var xz_velocity = Vector3(velocity.x, 0, velocity.z)
    var guess = xz_velocity * model.basis
    
    animation_tree.set("parameters/Locomotion/Locomotion/blend_position", Vector2(guess.x, -guess.z))
    
    if xz_velocity.length_squared() > 0.01:
        model.look_at(reticle.global_position)

func _physics_process(delta):
    var slowed_down = slowdown_cooldown > 0
    var speed = speed_while_shooting if slowed_down else regular_speed
    
    current_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var direction = (transform.basis * Vector3(current_input.x, 0, current_input.y)).normalized()
    if direction:
        velocity = lerp(velocity, direction * speed, delta * move_lag)
    else:
        velocity = lerp(velocity, Vector3.ZERO, delta * move_lag)

    move_and_slide()

var is_invincible
var invincibility_time = 0.5

func _on_damageable_damaged(damage_params):
    if is_invincible:
        return
        
    player_damaged.emit(damage_params)
    is_invincible = true
    var tween = create_tween()
    tween.tween_callback(func(): is_invincible = false).set_delay(invincibility_time)

func _on_shoot_handler_fired():
    slowdown_cooldown = slowdown_time

func _on_item_detection_picked(params):
    gain_exp.emit(1)
