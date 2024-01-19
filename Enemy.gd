extends CharacterBody3D

@onready var item_scene: PackedScene = load("res://item.tscn")
@onready var damage_indicator_scene: PackedScene = load("res://damage_indicator.tscn")
@onready var soft_collision_area: Area3D = $SoftCollision

var player
var speed
var move_lag : float = 16.0
var force_away_speed = 20.0
var force_away_multiplier = 1.0
var health: float
var enemy_type: EnemyType
var model

func _ready():
    model = enemy_type.model.instantiate()
    add_child(model)
    model.animation_player.play("RunFoward")
    health = enemy_type.health

func _physics_process(delta):
    if player:
        look_at(player.global_position, Vector3.UP)
        var new_velocity = -transform.basis.z * speed * force_away_multiplier
        velocity = lerp(velocity, Vector3(new_velocity.x, 0, new_velocity.z), delta * move_lag)
    else:
        velocity = lerp(velocity, Vector2.ZERO, delta * move_lag)
    force_away_from_other_enemies()

    move_and_slide()

func force_away_from_other_enemies():
    for collider in soft_collision_area.get_overlapping_areas():
        var force_away = global_position - collider.global_position
        var force_amt = 1 / clampf(force_away.length_squared(), 0.1, 1.0) * 0.5
        velocity += force_away.normalized() * force_amt

func init(in_player, type):
    player = in_player
    player.player_damaged.connect(force_away_from_damaged_player)
    enemy_type = type
    speed = enemy_type.speed

func force_away_from_damaged_player(params):
    var distance = (player.global_position - global_position).length()
    if distance < 3:
        var dir = (player.global_position - global_position).normalized()
        velocity += dir * -1 * force_away_speed
        force_away_multiplier = 0.0
        await get_tree().create_timer(0.1).timeout
        force_away_multiplier = 1.0

func damage(damage_params):
    health -= damage_params.damage
    var damage_indicator = damage_indicator_scene.instantiate()
    damage_indicator.text = Utils.format_whole(damage_params.damage * 10)
    damage_indicator.position = global_position + Vector3.UP * 2
    get_parent().add_child(damage_indicator)
    model.flash()
    if Utils.leq(health, 0):
        die()

func die():
    var item = item_scene.instantiate()
    item.position = position
    item.start(player)
    get_parent().add_child(item)
    player.player_damaged.disconnect(force_away_from_damaged_player)
    model.spawn_death_effect(get_parent())
    queue_free()

func _on_damage_area_area_entered(area):
    if area.has_method("damage"):
        area.damage({})
