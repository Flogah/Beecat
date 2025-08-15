extends StaticBody2D

@export var destruction_time:float = 10.0

@onready var goose_detector: Area2D = $GooseDetector
@onready var destruction_timer: Timer = $DestructionTimer



func _on_goose_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("goose"):
		destruction_timer.start()


func _on_goose_detector_body_exited(body: Node2D) -> void:
	if destruction_timer.time_left > 0:
		destruction_timer.stop()
		destruction_timer.wait_time = destruction_time


func _on_destruction_timer_timeout() -> void:
	queue_free()
