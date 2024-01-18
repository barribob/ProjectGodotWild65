extends Control

@onready var upgrade_choice_scene = load("res://upgrade.tscn")
@onready var upgrades_container = %UpgradesContainer

var upgrade_choices = []

func _ready():
    Console.add_command("upgrade", func(upgrade_name): add_upgrade(load("res://data/upgrades/%s.tres" % upgrade_name), UpgradeType.new()), 1)
    Console.add_command("su", open_and_pause)
    for i in 3:
        var upgrade_choice = upgrade_choice_scene.instantiate()
        upgrades_container.add_child(upgrade_choice)
        upgrade_choices.append(upgrade_choice)
        upgrade_choice.chosen.connect(upgrade_chosen)
    close_and_resume()

func leveled_up():
    open_and_pause()

func upgrade_chosen(upgrade):
    add_upgrade(upgrade.upgrade, upgrade.upgrade_type)
    close_and_resume()

func close_and_resume():
    get_tree().paused = false
    hide()

func open_and_pause():
    await get_tree().create_timer(0.5).timeout
    get_tree().paused = true
    show()
    var upgrades = get_available_upgrades()
    for i in 3:
        var random = randi_range(0, upgrades.size() - 1)
        var upgrade_type = upgrades.keys()[random]
        upgrade_choices[i].set_upgrade({upgrade_type = upgrade_type, upgrade = upgrades[upgrade_type]})
        upgrades.erase(upgrade_type)

var upgrades_by_type = {}
@onready var upgrade_types: UpgradeTypes = load("res://data/upgrades/upgrade_types.tres")

func get_available_upgrades():
    var available_types = {}
    for type in upgrade_types.types:
        if not upgrades_by_type.has(type):
            available_types[type] = type.upgrades[0]
        elif upgrades_by_type[type].size() < type.upgrades.size():
            available_types[type] = type.upgrades[upgrades_by_type[type].size()]
    return available_types

func add_upgrade(upgrade, upgrade_type):
    if not upgrades_by_type.has(upgrade_type):
        upgrades_by_type[upgrade_type] = []

    upgrades_by_type[upgrade_type].append(upgrade)
    EventBus.upgrade_added.emit(upgrades_by_type)
