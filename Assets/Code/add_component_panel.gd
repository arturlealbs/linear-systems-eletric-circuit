extends Window

signal confirmed_circuit_update(r: float, v: float)

enum{
	BATTERY,
	RESISTOR
}

var component = RESISTOR
var component_value: float = 0.0

@onready var resistor_button = $VBoxContainer2/HBoxContainer/ResistorButton
@onready var battery_button = $VBoxContainer2/HBoxContainer/BatteryButton
@onready var line_edit = $VBoxContainer2/HBoxContainer2/LineEdit
@onready var confirm_button = $VBoxContainer2/HBoxContainer3/ConfirmButton

func _ready():
	connect_signals()

func connect_signals() -> void:
	line_edit.invalid_input_updated.connect(on_invalid_input_updated)
	line_edit.valid_input_updated.connect(on_valid_input_updated)
	line_edit.valid_input_submitted.connect(_on_confirm_button_pressed)

func on_invalid_input_updated() -> void:
	confirm_button.disabled = true
	
func on_valid_input_updated(value:float) -> void:
	component_value = value
	confirm_button.disabled = false

func reset():
	line_edit.reset()
	resistor_button.button_pressed = true
	battery_button.button_pressed = false
	component = RESISTOR

func _on_resistor_button_pressed():
	component = RESISTOR

func _on_battery_button_pressed():
	component = BATTERY

func _on_confirm_button_pressed():
	match component:
		BATTERY:
			confirmed_circuit_update.emit(0, component_value)
		RESISTOR:
			confirmed_circuit_update.emit(component_value,0)
	hide()


func _on_cancel_butt2on_pressed():
	hide()

func _on_close_requested():
	hide()
