extends HBoxContainer

signal died

const damage_slow := 0.07
const damage_slow_time := 0.5
var health = 3
@onready var health_icon_scene: PackedScene = load("res://health_icon.tscn")
@onready var damaged_audio = load("res://sounds/Player_Damage_Hit_SFX_v1.wav")
@onready var death_audio =load("res://sounds/Player_death_SFX.wav")

func _ready():
    Console.add_command("sfx", func(): SoundManager.play_sound(damaged_audio))
    Console.add_command("die", func(): died.emit())
    for i in health:
        add_child(health_icon_scene.instantiate())

func _on_player_player_damaged(damage_params):
    if health == 0:
        return

    if health > 1:
        TimeManager.set_time_scale(damage_slow, damage_slow_time)
    if health > 0:
        health -= 1
        get_child(0).queue_free()
    if health <= 0:
        died.emit()
        SoundManager.play_sound(death_audio).process_mode = Node.PROCESS_MODE_ALWAYS
        await get_tree().create_timer(1.0).timeout
        TimeManager.pause_tree()
    else:
        SoundManager.play_sound(damaged_audio)
