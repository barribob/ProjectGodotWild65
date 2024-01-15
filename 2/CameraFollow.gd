extends Node3D

@export var target : Node3D
@export var min_offset : Vector3
@export var max_offset : Vector3
@export var lerp_speed = 3.0

func _physics_process(delta):
    if !target:
        return

    var new_offset = (target.global_position).clamp(min_offset, max_offset) - target.global_position

    var target_xform = target.global_transform.translated_local(new_offset)
    global_transform = global_transform.interpolate_with(target_xform, lerp_speed * delta)
