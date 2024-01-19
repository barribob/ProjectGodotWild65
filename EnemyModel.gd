extends Node3D

@onready var animation_player = %AnimationPlayer
@export var mesh: MeshInstance3D
@export var death_particles_scene: PackedScene

func flash():
    var tween = create_tween()
    tween.tween_method(set_flash, 1.0, 0, 0.2)

func set_flash(f):
    var material = mesh.material_overlay as ShaderMaterial
    material.set_shader_parameter("flash_lerp", f)

func spawn_death_effect(spawn_root):
    var particles = death_particles_scene.instantiate()
    particles.position = global_position
    spawn_root.add_child(particles)
