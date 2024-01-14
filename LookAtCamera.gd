extends Node3D

func _process(delta):
    var camera = get_viewport().get_camera_3d()
    look_at(camera.global_position, Vector3.UP)
