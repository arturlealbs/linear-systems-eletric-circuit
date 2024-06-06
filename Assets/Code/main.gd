extends Node


var currents: Array[float]

@onready var core = $Core
@onready var interface = $Interface

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_circuit()
	connect_interface()

func connect_interface() -> void:
	interface.sent_circuit_update.connect(handle_update_request)
	interface.cancelled_circuit_update.connect(abort_update_request)
	interface.emitted_flip_request.connect(request_flip)
	
func handle_update_request(id: int, r: float, v: float):
	currents.assign(core.HandleCircuitUpdateCall(id, r, v))
	if currents == []:
		interface.emit_short_circuit_alert()
	else:
		interface.update_circuit(currents)
		
func abort_update_request() -> void:
	core.AbortCircuitUpdateCall()

func request_flip(id: int) -> void:
	var temp_array: Array[float]
	temp_array.assign(core.FlipBatteryComponent(id))
	currents.assign(core.HandleCircuitUpdateCall(temp_array[0], temp_array[1], temp_array[2]))
	interface.update_circuit(currents)
	
func initialize_circuit() -> void:
	var temp_array: Array[float]
	
	temp_array.assign(core.HandleCircuitUpdateCall(1,1,0))
	temp_array.assign(core.HandleCircuitUpdateCall(5,1,0))
	temp_array.assign(core.HandleCircuitUpdateCall(7,1,0))
	temp_array.assign(core.HandleCircuitUpdateCall(11,1,0))
	
	temp_array.assign(core.HandleCircuitUpdateCall(4,0,5))
	temp_array.assign(core.HandleCircuitUpdateCall(6,0,5))
	
	interface.update_circuit(temp_array)
