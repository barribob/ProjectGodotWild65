extends Node

class_name UpgradeEvent

var shoot_handler
var event_type

func start(in_shoot_handler, in_event_type):
    shoot_handler = in_shoot_handler
    event_type = in_event_type

func trigger():
    if event_type == Enums.TriggerEvent.Spread5:
        shoot_handler.shoot_in_fan()
    if event_type == Enums.TriggerEvent.Circle:
        shoot_handler.shoot_in_circle()
