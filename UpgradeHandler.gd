extends Node

@onready var shoot_handler = %ShootHandler
@onready var player = $".."

var upgrades_by_type = {}

func _ready():
    Console.add_command("upgrade", func(upgrade_name): add_upgrade(load("res://data/%s.tres" % upgrade_name)), 1)

func add_upgrade(upgrade: Upgrade):
    if not upgrades_by_type.has(upgrade.upgrade_type):
        upgrades_by_type[upgrade.upgrade_type] = []
        
    upgrades_by_type[upgrade.upgrade_type].append(upgrade)
    recalculate_upgrade_type(upgrade.upgrade_type)
    
func recalculate_upgrade_type(upgrade_type):
    var fire_rate_upgrade = 0.0
    var reload_speed_upgrade = 0.0
    var clip_size_upgrade: int = 0
    var pick_up_range_upgrade = 0.0
    var move_speed_upgrade = 0.0
    
    for upgrade in upgrades_by_type[upgrade_type]:
        fire_rate_upgrade += upgrade.fire_rate
        reload_speed_upgrade += upgrade.reload_speed
        clip_size_upgrade += upgrade.clip_size
        pick_up_range_upgrade += upgrade.pick_up_range
        move_speed_upgrade += upgrade.move_speed
        
    shoot_handler.shoot_interval = shoot_handler.base_shoot_interval / (1 + fire_rate_upgrade)
    shoot_handler.reload_time = shoot_handler.base_reload_time / (1 + reload_speed_upgrade)
    shoot_handler.clip_size = shoot_handler.base_clip_size + clip_size_upgrade
    player.pick_up_range = player.base_pick_up_range * (1 + pick_up_range_upgrade)
    player.move_speed = player.base_speed * (1 + move_speed_upgrade)
