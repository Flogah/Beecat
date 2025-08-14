extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var jump_buffer_time: float = 0.1
var jump_buffer_timer: float = 0.0

var coyote_time:float = 0.5
var coyote_timer:float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	set_collision_mask_value(3, true) #for one way platforms
	jump_buffer_timer = 0
	coyote_timer = 0

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump") and coyote_timer > 0:
		jump_buffer_timer = jump_buffer_time
		jump()

func _process(delta: float) -> void:
	if jump_buffer_timer > 0: jump_buffer_timer -= delta
	if coyote_timer > 0: coyote_timer -= delta
	
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		coyote_timer = coyote_time
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	if direction:
		sprite.play("run")
		
		if direction > 0:
			sprite.flip_h = true
		if direction < 0:
			sprite.flip_h = false
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("sit")
	
	if Input.is_action_just_pressed("down"):
		set_collision_mask_value(3, false)
	if Input.is_action_just_released("down"):
		set_collision_mask_value(3, true)
	
	move_and_slide()


func jump() -> void:
	if jump_buffer_timer > 0 or coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
