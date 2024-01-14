extends CharacterBody3D

@onready var item_scene: PackedScene = load("res://item.tscn")

var player
var speed = 1.0

func _physics_process(delta):
    if player:
        look_at(player.global_position, Vector3.UP)
        velocity = -transform.basis.z * speed
        
    move_and_slide()

func init(in_player):
    player = in_player

func damage(damage_params):
    var item = item_scene.instantiate()
    item.position = position
    get_parent().add_child(item)
    queue_free()

func _on_damage_area_area_entered(area):
    if area.has_method("damage"):
        area.damage({})
