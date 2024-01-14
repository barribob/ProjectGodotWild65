extends CharacterBody3D

signal gain_exp(amt)
signal player_damaged(damage_params)

var speed_while_shooting = 2.0
var slowdown_time = 0.3
var slowdown_cooldown = 0.0
var regular_speed = 5.0

func _process(delta):
    slowdown_cooldown = clampf(slowdown_cooldown - delta, 0, slowdown_time)

func _physics_process(delta):
    var slowed_down = slowdown_cooldown > 0
    var speed = speed_while_shooting if slowed_down else regular_speed
    
    var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.z = move_toward(velocity.z, 0, speed)

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
