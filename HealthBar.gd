extends HBoxContainer

signal died

const damage_slow := 0.07
const damage_slow_time := 0.5
var health = 3
@onready var health_icon_scene: PackedScene = load("res://health_icon.tscn")

func _ready():
    Console.add_command("die", func(): died.emit())
    for i in health:
        add_child(health_icon_scene.instantiate())

func _on_player_player_damaged(damage_params):
    if health > 1:
        TimeManager.set_time_scale(damage_slow, damage_slow_time)
    if health > 0:
        health -= 1
        get_child(0).queue_free()
    if health <= 0:
        died.emit()
