extends CPUParticles3D

func _ready():
    emitting = true
    await get_tree().create_timer(2).timeout
    queue_free()
