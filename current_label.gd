extends Label

@export var current_id:int

func update_label(currents:Array[float]):
	if currents[current_id] == 0:
		text = str(0) + " A"
	else:
		text = str((currents[current_id])).pad_decimals(1) + " A"


