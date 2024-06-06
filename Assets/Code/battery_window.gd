extends ComponentWindow

signal battery_flip_requested()

func _on_invert_pressed():
	battery_flip_requested.emit()
	hide()
