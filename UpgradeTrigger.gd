extends Node

class_name UpgradeTrigger

var shoot_handler
var upgrade_event
var trigger_value: float

func start(in_shoot_handler, in_upgrade_event, trigger_type, in_trigger_value):
    upgrade_event = in_upgrade_event
    shoot_handler = in_shoot_handler
    trigger_value = in_trigger_value
    if trigger_type == Enums.TriggerType.EveryXShot:
        shoot_handler.fired.connect(on_fired)
    elif trigger_type == Enums.TriggerType.Reload:
        shoot_handler.reload_finish.connect(on_reload)

func on_reload():
    upgrade_event.trigger()

func on_fired():
    if shoot_handler.shot_counter % int(trigger_value) == 0:
        upgrade_event.trigger()
