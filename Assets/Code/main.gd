extends Node

@onready var back_end = $"Back End"
@onready var front_end = $"Front End"

# Called when the node enters the scene tree for the first time.
func _ready():
	var test = back_end.HandleCircuitUpdateCall(1, 1, 0)
	print(test)
	test = back_end.HandleCircuitUpdateCall(5, 1, 0)
	print(test)
	test = back_end.HandleCircuitUpdateCall(7, 1, 0)
	print(test)
	test = back_end.HandleCircuitUpdateCall(9, 1, 0)
	print(test)
	test = back_end.HandleCircuitUpdateCall(4, 0, 5)
	print(test)
	test = back_end.HandleCircuitUpdateCall(6, 0, 5)
	print(test)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
