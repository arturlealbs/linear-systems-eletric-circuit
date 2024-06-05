extends LineEdit

signal valid_input_submitted()
signal valid_input_updated(value: float)
signal invalid_input_updated()

func reset():
	text = ""

func validate_input(new_text:String) -> bool:
	return (new_text.is_valid_float() and float(new_text) >= 0)

func _on_text_changed(new_text:String):
	if validate_input(new_text):
		valid_input_updated.emit(float(new_text))
	else:
		invalid_input_updated.emit()

func _on_text_submitted(new_text):
	if validate_input(new_text):
		valid_input_updated.emit(float(new_text))
		valid_input_submitted.emit()
