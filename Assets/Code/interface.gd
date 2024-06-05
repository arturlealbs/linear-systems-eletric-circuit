extends Node

signal sent_circuit_update(id: int, r: float, v:float)
signal cancelled_circuit_update()

var edge_id:int
var is_in_short_circuit:bool = false
var can_emit_short_circuit_alert:bool = true

@onready var labels = $Labels
@onready var edges = $Edges
@onready var add_component_panel = $Panels/AddComponentPanel
@onready var short_circuit_warning_panel = $Panels/ShortCircuitWarningPanel

# Called when the node enters the scene tree for the first time.
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
	
func display_component_popup(id: int) -> void:
	edge_id = id
	add_component_panel.reset()
	add_component_panel.show()

func get_components_value(r:float, v:float):
	sent_circuit_update.emit(edge_id, r, v)

func update_circuit(currents: Array[float]) -> void:
	if is_in_short_circuit:
		set_short_circuit(false)
	update_labels(currents)
	
func update_labels(currents: Array[float]):
	for label in labels.get_children():
		label.update_label(currents)
		
func emit_short_circuit_alert():
	if can_emit_short_circuit_alert:
		short_circuit_warning_panel.show()

func cancel_circuit_update() -> void:
	cancelled_circuit_update.emit()

func set_short_circuit(b: bool) -> void:
	is_in_short_circuit = b
	for group in get_children():
		if group.name == "Labels":
			for label in group.get_children():
				label.visible = not b
		if group.name != "Panels":
			for child in group.get_children():
				if b:
					child.modulate = Color(0.5, 0.5, 0.5, 1)
				else:
					child.modulate = Color(1, 1, 1, 1)

func block_short_circuit_alert() -> void:
	can_emit_short_circuit_alert = false
