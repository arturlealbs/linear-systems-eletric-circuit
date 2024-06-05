extends Node

signal pressed_edge(id: int)

@export var id: int

func _on_button_up():
	pressed_edge.emit(id)
	
