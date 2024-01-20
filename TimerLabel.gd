extends Label

var time: float = 60 * 3.5
var is_running: bool

func _ready():
    Console.add_command("win", func(): EventBus.win_game.emit())
    is_running = true

func set_timer_text():
    is_running = false

func _process(delta):
    if is_running:
        time = clampf(time - delta, 0, time)
        text = "%.0f.%02d.%02d" % [floor(time / 60), fmod(time, 60), fmod(time * 100, 100)]
        if Utils.leq(time, 0):
            is_running = false
            EventBus.win_game.emit()
