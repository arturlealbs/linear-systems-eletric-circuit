extends Node

signal pressed_edge(id: int)
signal sent_delete_request(id:int)
signal sent_flip_request(id:int)

@export var id: int
@export var current_id: int
@export var battery_flipped: bool

@export_enum("WIRE", "BATTERY", "RESISTOR") var component: String = "WIRE"

@onready var current_flow = $CurrentFlow
@onready var battery = $Battery
@onready var resistor = $Resistor


func _ready():
	match  component:
		"BATTERY":
			updated_wire(0, 5)
		"RESISTOR":
			updated_wire(1, 0)
		"WIRE":
			updated_wire(0, 0)
			
	if battery_flipped:
		battery.flip()
		
	resistor.submited_edit_request.connect(_on_button_up)
	resistor.submited_delete_request.connect(send_delete_request)
	
	battery.submited_edit_request.connect(_on_button_up)
	battery.submited_delete_request.connect(send_delete_request)
	battery.submited_battery_flip.connect(send_flip_request)

func send_flip_request() -> void:
	sent_flip_request.emit(id)
	battery.flip()

func send_delete_request() -> void:
	sent_delete_request.emit(id)
	
func _on_button_up():
	pressed_edge.emit(id)
	
func updated_wire(r:float, v:float) -> void:
	if r == 0:
		resistor.visible = false
	else:
		resistor.update_component_text(r)
		resistor.visible = true
	
	if v == 0:
		battery.visible = false
	else:
		battery.visible = true
		battery.update_component_text(v)
		
	

