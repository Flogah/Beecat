extends CharacterBody2D




const GRAVITY_MULTIPLIER = 2.0

@export var move_speed = 200.0
@export var jump_height:float = 50

var jump_velocity:float
var bonus_jumps:int = 0
var jumps_left:int

var jump_buffer_time: float = 0.1
var jump_buffer_timer: float = -1
var coyote_time:float = 0.1
var coyote_timer:float = -1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gravity :Vector2 = Vector2(0, ProjectSettings.get_setting("physics/2d/default_gravity"))

func _ready() -> void:
	set_collision_mask_value(3, true) #for one way platforms
	jump_velocity = -(sqrt(jump_height * 2.0 * gravity.y))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		jump()

	if Input.is_action_just_released("jump"):
		velocity.y *= 0.5

func _process(delta: float) -> void:
	if coyote_timer > 0: coyote_timer -= delta
	if jump_buffer_timer > 0: jump_buffer_timer -= delta

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	if direction:
		sprite.play("run")
		if direction > 0:
			sprite.flip_h = true
		if direction < 0:
			sprite.flip_h = false
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		sprite.play("idle")
	
	# on holding down, phase through one-way collision platforms
	if Input.is_action_just_pressed("down"):
		set_collision_mask_value(3, false)
	if Input.is_action_just_released("down"):
		set_collision_mask_value(3, true)
	
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			velocity += gravity * GRAVITY_MULTIPLIER * delta
			sprite.play("falling")
		else:
			velocity += gravity * delta
			sprite.play("jump")
			
	if is_on_floor():
		coyote_timer = coyote_time
		jumps_left = bonus_jumps
		if jump_buffer_timer > 0:
			jump()
			jump_buffer_timer = -1
		
	
	move_and_slide()

func jump() -> void:
	if can_jump(): velocity.y = jump_velocity
	else: jump_buffer_timer = jump_buffer_time

func can_jump() -> bool: 
	if is_on_floor():
		return true
	elif coyote_timer > 0:
		print("Coyote time!")
		coyote_timer = -1
		return true
	elif jumps_left > 0:
		print("Jumps left: " + str(jumps_left))
		jumps_left -= 1
		return true
	elif jump_buffer_timer <= 0:
		jump_buffer_timer = jump_buffer_time
		print("Jump Buffer time!")
		return false
	return false
