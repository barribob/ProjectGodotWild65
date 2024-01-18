extends VBoxContainer

@export var full_texture: Texture2D
@export var empty_texture: Texture2D

var max_to_show = 10

func _ready():
    EventBus.ammo_updated.connect(ammo_updated)
    for i in max_to_show:
        add_child(TextureRect.new())

func ammo_updated(ammo, max_ammo):
    for i in get_child_count():
        if ammo > i:
            get_child(i).texture = full_texture
        elif max_ammo > i:
            get_child(i).texture = empty_texture
        else:
            get_child(i).texture = null
