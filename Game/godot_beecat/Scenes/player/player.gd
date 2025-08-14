extends CharacterBody2D


const SPEED = 300.0

const GRAVITY_MULTIPLIER = 2.0

@export var jump_height:float = 50

var jump_velocity:float
var jumps:int = 2
var jumps_left:int = 1

var jump_buffer_time: float = 0.1
var jump_buffer_timer: float = 0.0
var coyote_time:float = 0.1
var coyote_timer:float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gravity :Vector2 = Vector2(0, ProjectSettings.get_setting("physics/2d/default_gravity"))

func _ready() -> void:
	set_collision_mask_value(3, true) #for one way platforms
	jump_velocity = -(sqrt(jump_height * 2.0 * gravity.y))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump") and coyote_timer > 0:
		jump()
		coyote_timer = -1

	if Input.is_action_just_released("jump"):
		velocity.y *= 0.5

func _process(delta: float) -> void:
	coyote_timer -= delta
	
	

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
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("sit")
	
	if Input.is_action_just_pressed("down"):
		set_collision_mask_value(3, false)
	if Input.is_action_just_released("down"):
		set_collision_mask_value(3, true)
	
		# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			velocity += gravity * GRAVITY_MULTIPLIER * delta
			sprite.play("fall")
		else:
			velocity += gravity * delta
			sprite.play("jump")
			
	if is_on_floor():
		coyote_timer = coyote_time
		jumps_left = jumps
	
	move_and_slide()


func jump() -> void:
	if jumps_left > 0:
		velocity.y = jump_velocity
		if jumps_left > 0 : jumps_left   -= 1
