extends Camera2D

@export var focus: Node

@export var move_speed:float = 0.1


func _physics_process(delta: float) -> void:
	if focus:
		position = position.lerp(focus.position, move_speed)
