extends Control

signal leveled

var exp = 0
var max_exp = 0
var current_level = 0

@onready var exp_bar = %ExpBar
@onready var level_data: LevelsData = load("res://data/levels_data.tres")

func _ready():
    Console.add_command("exp", func(e): gain_exp(int(e)), 1)
    $"../Player".gain_exp.connect(gain_exp)
    max_exp = level_data.levels[0]
    exp_bar.max_value = max_exp    

func gain_exp(amt):
    exp += amt
    while exp > max_exp:
        exp -= max_exp
        current_level += 1
        max_exp = level_data.levels[current_level]
        leveled.emit()
    
    exp_bar.value = exp
    exp_bar.max_value = max_exp
