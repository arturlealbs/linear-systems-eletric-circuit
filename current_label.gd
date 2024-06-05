extends Label

@export var current_id:int

func update_label(currents:Array[float]):
	text = str(abs(currents[current_id])).pad_decimals(1) + " A"

