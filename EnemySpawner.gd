extends Node3D

class_name EnemySpawner

@export var waves: EnemyWaves
@export var telegraph_spawn_delay: float
@export var spawn_positions: Node3D
@export var player: Node3D

@onready var enemy_scene = load("res://enemy.tscn")

var current_wave_index

func _ready():
    Console.add_command("sp", start_waves)

func start_waves():
    current_wave_index = -1
    _start_spawning()

func _start_spawning():
    current_wave_index += 1
    if current_wave_index >= waves.waves.size():
        print("All waves spawned")
        return
    var enemy_spawn = waves.waves[current_wave_index]
    var tween = create_tween()
    for i in enemy_spawn.spawn_amount:
        tween.tween_callback(_spawn_enemy).set_delay(enemy_spawn.initial_delay if i == 0 else enemy_spawn.in_between_delay)
    tween.tween_callback(_start_spawning)

func _spawn_enemy():
    var available_positions = [] + spawn_positions.get_children()

    while available_positions.size() > 0:
        var random_position = available_positions[randi() % available_positions.size()]
        available_positions.remove_at(available_positions.find(random_position))
        if random_position.get_overlapping_areas().size() == 0:
            var enemy_spawn = waves.waves[current_wave_index]
            var enemy_instance = enemy_scene.instantiate()
            enemy_instance.init(player, enemy_spawn.enemy_type)
            enemy_instance.position = random_position.global_position
            add_child(enemy_instance)
            return
