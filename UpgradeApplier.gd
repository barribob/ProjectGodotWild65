extends Node

@onready var shoot_handler = %ShootHandler
@onready var player = $".."

func _ready():
    EventBus.upgrade_added.connect(recalculate_upgrade_type)

func recalculate_upgrade_type(upgrades_by_type):
    var fire_rate_upgrade = 0.0
    var reload_speed_upgrade = 0.0
    var clip_size_upgrade: int = 0
    var pick_up_range_upgrade = 0.0
    var move_speed_upgrade = 0.0
    var damage_upgrade = 0.0
    for child in get_children():
        child.queue_free()

    for upgrade_type in upgrades_by_type:
        for upgrade in upgrades_by_type[upgrade_type]:
            fire_rate_upgrade += upgrade.fire_rate
            reload_speed_upgrade += upgrade.reload_speed
            clip_size_upgrade += upgrade.clip_size
            pick_up_range_upgrade += upgrade.pick_up_range
            move_speed_upgrade += upgrade.move_speed
            damage_upgrade += upgrade.damage
            if upgrade.trigger_type != Enums.TriggerType.None and upgrade.trigger_event != Enums.TriggerEvent.None:
                var event = UpgradeEvent.new()
                event.start(shoot_handler, upgrade.trigger_event)
                var trigger = UpgradeTrigger.new()
                trigger.start(shoot_handler, event, upgrade.trigger_type, upgrade.trigger_value)
                add_child(trigger)

    shoot_handler.shoot_interval = shoot_handler.base_shoot_interval / (1 + fire_rate_upgrade)
    shoot_handler.reload_time = shoot_handler.base_reload_time / (1 + reload_speed_upgrade)
    shoot_handler.clip_size = shoot_handler.base_clip_size + clip_size_upgrade
    player.pick_up_range = player.base_pick_up_range * (1 + pick_up_range_upgrade)
    player.move_speed = player.base_speed * (1 + move_speed_upgrade)
    shoot_handler.damage = shoot_handler.base_damage * (1 + damage_upgrade)
