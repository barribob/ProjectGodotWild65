extends Control

var exp = 0
var max_exp = 10

@onready var exp_bar = %ExpBar

func _ready():
    $"../Player".gain_exp.connect(gain_exp)
    exp_bar.max_value = max_exp

func gain_exp(amt):
    exp += amt
    exp_bar.value = exp
