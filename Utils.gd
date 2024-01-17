extends Node

class_name Utils

static func get_3d_mouse_pos(y_pos: float, node: Node3D, camera: Camera3D):
    var plane_position = Vector3(0, y_pos, 0)
    var mouse_pos = node.get_viewport().get_mouse_position()
    var ray_origin = camera.project_ray_origin(mouse_pos)
    var ray_direction = camera.project_ray_normal(mouse_pos)

    var intersection_point = Vector3()

    # Calculate the intersection of the ray with the plane
    var plane_normal = Vector3(0, 1, 0)  # Assuming the plane is oriented horizontally
    var d = -plane_position.dot(plane_normal)
    var t = -(ray_origin.dot(plane_normal) + d) / ray_direction.dot(plane_normal)

    if t >= 0:
        intersection_point = ray_origin + ray_direction * t
        return intersection_point

    return Vector3.ZERO

static func geq(f1: float, f2: float):
    return f1 > f2 || is_equal_approx(f1, f2)

static func leq(f1: float, f2: float):
    return f1 < f2 || is_equal_approx(f1, f2)

static func format_whole(number):
    return "%.0f" % number
