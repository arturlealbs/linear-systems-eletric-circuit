extends Window

signal confirmed_circuit_update()
signal cancelled_circuit_update()
signal blocked_short_circuit_warning()

func _on_confirm_pressed():
	confirmed_circuit_update.emit()
	hide()

func _on_cancel_pressed():
	cancelled_circuit_update.emit()
	hide()

func _on_dont_show_again_toggled(toggled_on):
	blocked_short_circuit_warning.emit()
