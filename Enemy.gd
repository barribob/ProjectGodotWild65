extends CharacterBody3D

@onready var item_scene: PackedScene = load("res://item.tscn")

var player
var speed = 3.0
var move_lag : float = 16.0
var force_away_speed = 20.0
@onready var animation_player = %AnimationPlayer

func _ready():
    animation_player.play("RunFoward")

func _physics_process(delta):
    if player:
        look_at(player.global_position, Vector3.UP)
        velocity = lerp(velocity, -transform.basis.z * speed, delta * move_lag)
    else:
        velocity = lerp(velocity, Vector2.ZERO, delta * move_lag)
        
    move_and_slide()

func init(in_player):
    player = in_player
    player.player_damaged.connect(force_away)
    
func force_away(params):
    var distance = (player.global_position - global_position).length()
    if distance < 3:
        var dir = (player.global_position - global_position).normalized()
        velocity += dir * -1 * force_away_speed

func damage(damage_params):
    var item = item_scene.instantiate()
    item.position = position
    item.start(player)
    get_parent().add_child(item)
    player.player_damaged.disconnect(force_away)
    queue_free()

func _on_damage_area_area_entered(area):
    if area.has_method("damage"):
        area.damage({})
