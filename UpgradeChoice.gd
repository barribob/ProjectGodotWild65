extends Control

signal chosen(upgrade)

var upgrade

func _on_button_pressed():
    chosen.emit(upgrade)

func set_upgrade(in_upgrade):
    upgrade = in_upgrade
    $MarginContainer/HBoxContainer/Label.text = upgrade.upgrade_type.name + "\n" + upgrade.upgrade.description
    $MarginContainer/HBoxContainer/TextureRect.texture = upgrade.upgrade_type.texture
