extends Node3D

func _on_area_3d_area_entered(area):
    if area.has_method("pick"):
        area.pick({})
    queue_free()
