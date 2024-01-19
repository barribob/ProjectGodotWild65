extends Node3D

@onready var music = load("res://sounds/Map_Loop_v1.mp3")

func _ready():
    SoundManager.play_music_at_volume(music, -10)
