extends Node3D

@onready var music = load("res://sounds/Map_Loop_v1.mp3")
@onready var spawner = $EnemySpawner

func _ready():
    if (!OS.is_debug_build()):
        SoundManager.play_music_at_volume(music, -10)
        spawner.start_waves()
