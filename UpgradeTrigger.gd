extends Node

class_name UpgradeTrigger

var shoot_handler
var upgrade_event
var trigger_value: float

func start(in_shoot_handler, in_upgrade_event, in_trigger_value):
    upgrade_event = in_upgrade_event
    shoot_handler = in_shoot_handler
    trigger_value = in_trigger_value
    shoot_handler.fired.connect(on_fired)

func on_fired():
    if shoot_handler.shot_counter % int(trigger_value) == 0:
        upgrade_event.trigger()
