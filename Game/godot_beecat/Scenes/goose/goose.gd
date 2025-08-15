extends CharacterBody2D

var hunting:bool = false
var target
var hunting_direction:int = 0
var hunting_deadzone_radius:float = 40
var move_speed:float = 300

@onready var goose_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	check_target_pos()
	hunt_target()

func check_target_pos():
	if !hunting: return
	if target.position.x > position.x + hunting_deadzone_radius:
		hunting_direction = 1
		goose_sprite.flip_h = false
	elif target.position.x < position.x - hunting_deadzone_radius:
		hunting_direction = -1
		goose_sprite.flip_h = true
	else:
		hunting_direction = 0

func hunt_target():
	if !hunting: return
	if hunting_direction == 0:
		goose_sprite.play("bark")
		velocity.x = move_toward(velocity.x, 0, 2)
	else:
		if (velocity.x > 0 and hunting_direction == -1) or (velocity.x < 0 and hunting_direction == 1):
			goose_sprite.play("sliding")
			if velocity.x < 0:
				goose_sprite.flip_h = true
			else:
				goose_sprite.flip_h = false
		else:
			goose_sprite.play("run")
		velocity.x = move_toward(velocity.x, move_speed * hunting_direction, 10)
	
	move_and_slide()

func _on_threat_area_body_entered(body: Node2D) -> void:
	target.fear()

func _on_fight_area_body_entered(body: Node2D) -> void:
	hunting = false
	target.disable()
	target.visible = false
	goose_sprite.play("fight")
