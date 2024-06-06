extends Node

signal sent_circuit_update(id: int, r: float, v:float)
signal cancelled_circuit_update()
signal emitted_flip_request()

var edge_id:int
var update_r: float
var update_v: float
var is_in_short_circuit:bool = false
var can_emit_short_circuit_alert:bool = true

@onready var labels = $Labels
@onready var edges = $Edges
@onready var add_component_panel = $Panels/AddComponentPanel
@onready var short_circuit_warning_panel = $Panels/ShortCircuitWarningPanel


func _ready():
	connect_edges()
	connect_panels()
	
func connect_panels() -> void:
	add_component_panel.confirmed_circuit_update.connect(get_components_value)
	short_circuit_warning_panel.confirmed_circuit_update.connect(set_short_circuit)
	short_circuit_warning_panel.cancelled_circuit_update.connect(cancel_circuit_update)
	short_circuit_warning_panel.blocked_short_circuit_warning.connect(block_short_circuit_alert)
	
func connect_edges() -> void:
	for child in edges.get_children():
		child.pressed_edge.connect(display_component_popup)
		child.sent_delete_request.connect(delete_component)
		child.sent_flip_request.connect(emit_flip_request)
	
func display_component_popup(id: int) -> void:
	edge_id = id
	add_component_panel.reset()
	add_component_panel.show()

func delete_component(id: int) -> void:
	edge_id = id
	update_r = 0
	update_v = 0
	sent_circuit_update.emit(id, 0, 0)

func get_components_value(r:float, v:float):
	update_r = r
	update_v = v
	sent_circuit_update.emit(edge_id, r, v)

func update_circuit(currents: Array[float]) -> void:
	if is_in_short_circuit:
		set_short_circuit(false)
	update_labels(currents)
	update_edges(currents)

func update_edges(currents: Array[float]):
	for edge in edges.get_children():
		edge.current_flow.update_flow(currents[edge.current_id])
		if edge.id == edge_id:
			edge.updated_wire(update_r, update_v)

func update_labels(currents: Array[float]):
	for label in labels.get_children():
		label.update_label(currents)

func emit_short_circuit_alert():
	if can_emit_short_circuit_alert:
		short_circuit_warning_panel.show()
	else:
		set_short_circuit(true)

func cancel_circuit_update() -> void:
	cancelled_circuit_update.emit()

func set_short_circuit(b: bool) -> void:
	is_in_short_circuit = b
	for group in get_children():
		if group.name == "Labels":
			for label in group.get_children():
				label.visible = not b
				
		elif group.name == "Edges":
			for edge in group.get_children():
				if b:
					edge.modulate = Color(0.5, 0.5, 0.5, 1)
				else:
					edge.modulate = Color(1, 1, 1, 1)
				
				if edge.id == edge_id:
					edge.updated_wire(update_r, update_v)
				edge.current_flow.animation_player.active = not b
					
		elif group.name == "Vertices":
			for vertex in group.get_children():
				if b:
					vertex.modulate = Color(0.5, 0.5, 0.5, 1)
				else:
					vertex.modulate = Color(1, 1, 1, 1)

func block_short_circuit_alert() -> void:
	can_emit_short_circuit_alert = false

func emit_flip_request(id: int) -> void:
	emitted_flip_request.emit(id)
	
