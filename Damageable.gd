extends Area3D

signal damaged(params)

func damage(damage_params):
    damaged.emit(damage_params)
