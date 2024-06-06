extends Node2D

signal submited_edit_request()
signal submited_delete_request()

var unit:String = "Ω"

@onready var component_window = $ComponentWindow

func _ready():
	update_component_text(0)
	component_window.edit_component_requested.connect(submit_edit_request)
	component_window.delete_component_requested.connect(submit_delete_request)

func submit_edit_request() -> void:
	submited_edit_request.emit()
	
func submit_delete_request() -> void:
	submited_delete_request.emit()

func _on_area_2d_mouse_entered():
	component_window.show()
	component_window.position = global_position - Vector2(75,0)

func update_component_text(value:float) -> void:
	component_window.component_type.text = name + ": " + str(value).pad_decimals(1) + unit
