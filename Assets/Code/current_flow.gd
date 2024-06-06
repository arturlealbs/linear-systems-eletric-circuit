extends Node2D

const FLOW_COEFFICIENT:float = 0.2
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("flow")

func update_flow(current:float):
	if current == 0:
		visible = false
	else:
		visible = true
		animation_player.speed_scale = current * FLOW_COEFFICIENT + (1 if current >= 0 else -1)

