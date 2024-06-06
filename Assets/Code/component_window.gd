class_name ComponentWindow
extends Window

signal edit_component_requested()
signal delete_component_requested()
@onready var component_type = $VBoxContainer/Title


func _on_mouse_exited():
	hide()


func _on_edit_button_pressed():
	edit_component_requested.emit()
	hide()

func _on_delete_button_pressed():
	print("emitiu")
	delete_component_requested.emit()
	hide()
