extends Control

@export_file("*.tscn") var main_menu_scene : String

func _ready():
    hide()

func _on_restart_button_pressed():
    SceneLoader.reload_current_scene()
    InGameMenuController.close_menu()

func _on_main_menu_button_pressed():
    SceneLoader.load_scene(main_menu_scene)
    InGameMenuController.close_menu()
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_exit_button_pressed():
    get_tree().quit()

func _on_health_died():
    show()
