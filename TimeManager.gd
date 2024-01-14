extends Node

var freeze_time = 0

func set_time_scale(time_scale, time_at_time_scale):
    Engine.time_scale = time_scale
    freeze_time = time_at_time_scale

func _process(delta):
    if freeze_time > 0:
        freeze_time -= (delta / Engine.time_scale)
        if freeze_time <= 0:
            Engine.time_scale = 1
