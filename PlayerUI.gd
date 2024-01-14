extends CanvasLayer

@onready var progress_bar = $Control/ReloadBar

var current_tween

func _ready():
    progress_bar.max_value = 1.0
    progress_bar.hide()

func _on_shoot_handler_reload_start(cooldown):
    if current_tween:
        current_tween.kill()
        
    current_tween = create_tween()
    progress_bar.show()
    progress_bar.value = 0
    current_tween.tween_property(progress_bar, "value", 1.0, cooldown)
    current_tween.tween_callback(progress_bar.hide)

func _on_shoot_handler_reload_cancel():
    progress_bar.hide()    
