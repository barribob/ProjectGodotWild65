extends Control

signal chosen(upgrade)

func _on_button_pressed():
    chosen.emit({})
