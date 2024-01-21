extends Control

signal chosen(upgrade)

var button_sound = load("res://sounds/Menu_option_chosen_clicked_SFX.wav")
var upgrade

func _on_button_pressed():
    chosen.emit(upgrade)
    SoundManager.play_ui_sound(button_sound)

func set_upgrade(in_upgrade):
    upgrade = in_upgrade
    $MarginContainer/HBoxContainer/Label.text = upgrade.upgrade_type.name + "\n" + upgrade.upgrade.description
    $MarginContainer/HBoxContainer/TextureRect.texture = upgrade.upgrade_type.texture
