class_name PlayerController extends CharacterBody3D

@export var debug : bool = false

@export_category("Player Settings")
@export_group("Movement")
@export var acceleration : float = 10.0
@export var deceleration : float = 5.0
@export var jump_velocity : float = 5.0
@export var speed : float = 30.0

var _input_dir : Vector2 = Vector2.ZERO
var _movement_velocity : Vector3 = Vector3.ZERO




func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	_input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var current_velocity = Vector2(_movement_velocity.x, _movement_velocity.z)
	var direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
	
	if direction:
		current_velocity = lerp(current_velocity, Vector2(direction.x, direction.z) * speed, acceleration) * delta
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, deceleration) * delta
	
	_movement_velocity = Vector3(current_velocity.x, velocity.y, current_velocity.y)
	velocity = _movement_velocity

	move_and_slide()

func update_rotation(rotation_input) -> void:
	global_transform.basis = Basis.from_euler(rotation_input)
