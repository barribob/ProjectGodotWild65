extends Control

func _ready():
    close_and_resume()

func leveled_up():
    open_and_pause()

func upgrade_chosen(upgrade):
    close_and_resume()

func close_and_resume():
    get_tree().paused = false
    hide()

func open_and_pause():
    await get_tree().create_timer(0.5).timeout
    get_tree().paused = true
    show()
