extends Node

var freeze_time = 0

func _ready():
    Console.add_command("slow", func(): set_time_scale(0.07, 0.3))

func set_time_scale(time_scale, time_at_time_scale):
    Engine.time_scale = time_scale
    freeze_time = time_at_time_scale

func _process(delta):
    if freeze_time > 0:
        freeze_time -= (delta / Engine.time_scale)
        if freeze_time <= 0:
            Engine.time_scale = 1

func unpause_tree():
    get_tree().paused = false
    freeze_time = 0
    Engine.time_scale = 1

func pause_tree():
    get_tree().paused = true
