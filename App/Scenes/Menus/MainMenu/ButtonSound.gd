extends Button

var button_sound = load("res://sounds/Menu_option_chosen_clicked_SFX.wav")

func _ready():
    pressed.connect(func(): SoundManager.play_ui_sound(button_sound))
