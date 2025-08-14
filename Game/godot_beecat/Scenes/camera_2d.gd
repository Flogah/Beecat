extends Camera2D

@export var target: Node

@export var move_speed:float = 0.05

func _ready() -> void:
	if target: position = target.position

func _physics_process(delta: float) -> void:
	if target:
		if target.is_in_group("player"):
			var target_velocity = target.velocity
			var h_look_ahead = clampf(target_velocity.x, -100, 100)
			var v_look_ahead = clampf(target_velocity.y, -50, 50)
			var look_ahead_vector = Vector2(h_look_ahead, v_look_ahead)
			position = position.lerp(target.position + look_ahead_vector, move_speed)
		else: position = position.lerp(target.position, move_speed * 2)
	
