extends Node2D

signal submited_edit_request()
signal submited_delete_request()
signal submited_battery_flip()

var unit:String = "V"
@onready var sprite_2d = $Sprite2D
@onready var battery_window = $BatteryWindow

func _ready():
	battery_window.component_type.text = name
	battery_window.edit_component_requested.connect(submit_edit_request)
	battery_window.delete_component_requested.connect(submit_delete_request)
	battery_window.battery_flip_requested.connect(submit_battery_flip)

func submit_battery_flip() -> void:
	submited_battery_flip.emit()

func submit_edit_request() -> void:
	submited_edit_request.emit()
	
func submit_delete_request() -> void:
	submited_delete_request.emit()

func _on_area_2d_mouse_entered():
	battery_window.show()
	battery_window.position = global_position - Vector2(75,25)
	
func flip() -> void:
	sprite_2d.flip_v = not sprite_2d.flip_v

func update_component_text(value:float) -> void:
	battery_window.component_type.text = name + ": " + str(value).pad_decimals(1) + unit
