extends Label3D

const time = 1.0

func _ready():
    var tween = create_tween()
    tween.set_parallel()
    tween.tween_property(self, "position", position + Vector3.UP, time)
    tween.tween_property(self, "modulate", Color(0, 0, 0, 0), time).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
    tween.tween_property(self, "scale", scale * 0.5, time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
    tween.tween_callback(func(): queue_free()).set_delay(time)
