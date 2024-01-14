extends Area3D

signal picked(params)

func pick(params):
    picked.emit(params)
