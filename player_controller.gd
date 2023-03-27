extends CharacterBody3D

@export var speed = 14
@export var jump_strength = 20.0
@export var  fall_acceleration = 75

var snap_vector = Vector3.DOWN

var target_velocity = Vector3.ZERO

@onready var _spring_arm: SpringArm3D = $SpringArm3D


func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
		
	# Look where the camera is pointing
	# Normalise vector magnitude
	if direction != Vector3.ZERO:
		direction = direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()
		
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Vertical Velocity
	var just_landed = is_on_floor() and snap_vector == Vector3.ZERO
	var is_jumping = is_on_floor() and Input.is_action_just_pressed("jump")
	
	if is_jumping:
		target_velocity.y = jump_strength
		snap_vector = Vector3.ZERO
	elif just_landed:
		snap_vector = Vector3.DOWN
	if not is_on_floor() and snap_vector == Vector3.ZERO: # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# magic movements
	velocity = target_velocity
	move_and_slide()
	
	
	# Rotate Character to camera direction
	if velocity.length() > 0.2:
		var look_direction = Vector2(velocity.z, velocity.x)
		rotation.y = look_direction.angle()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_spring_arm.position = position
