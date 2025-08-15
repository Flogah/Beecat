extends Camera2D

var out_of_frame = false
@export var camera_offset:Vector2 = Vector2(0, -60)

var small_zoom = 2.5
var zoom_speed = .02
var zoom_in = false

@export var target: Node
@export_range(0.01, .1, 0.01) var move_speed:float = 0.05
@export var zoom_area_node:Node2D
@export_range(1.0, 2.5, .1) var zoom_level:float = 1.0

func _ready() -> void:
	for area in zoom_area_node.get_children():
		area.body_entered.connect(_on_small_space_body_entered)
		area.body_exited.connect(_on_small_space_body_exited)
	find_target()

func _physics_process(delta: float) -> void:
	if zoom_in:
		var camera_zoom = move_toward(zoom.x, small_zoom, zoom_speed)
		zoom = Vector2(camera_zoom, camera_zoom)
	else:
		var camera_zoom = move_toward(zoom.x, zoom_level, zoom_speed)
		zoom = Vector2(camera_zoom, camera_zoom)
	
	if target:
		if !target.is_in_group("player"):
			position = position.lerp(target.position, move_speed * 2)
		else:
			var look_ahead_vector = Vector2(target.velocity.x, target.velocity.y/2)
			position = position.lerp(target.position + (camera_offset * (1/zoom.x)) + look_ahead_vector, move_speed)

func find_target():
	if target: return
	target = get_tree().get_first_node_in_group("player")

func _on_small_space_body_entered(body: Node2D) -> void:
	zoom_in = true


func _on_small_space_body_exited(body: Node2D) -> void:
	zoom_in = false
