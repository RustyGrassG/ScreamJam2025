class_name PlayerController extends CharacterBody3D
#Toggles debug code
@export var debug: bool = false

var _input_dir : Vector2 = Vector2.ZERO
var _movement_velocity : Vector3 = Vector3.ZERO
var speed = 3.0

#How fast the player gets to max speed
var acceleration : float = 1.0
#How fast the player goes from their current speed to 0
var deceleration : float = 2.0

#Players current direction
var direction

#This is all debug, make sure debug is disabled before the game is launched
var god_mode : bool = false
var can_fly : bool = false
var clipping : bool = false
@onready var light: OmniLight3D = $light

func _physics_process(delta: float) -> void:
	#if the player is in the air(and can not fly), use gravity value to pull player back to floor
	if not is_on_floor() and not can_fly:
		velocity += get_gravity() * delta
	
	#gets the input direction as a vector2 value
	_input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	#Sets current velocity to movement velocity. i actually dont know why this is used really... But keep it here!
	var current_velocity = Vector2(_movement_velocity.x, _movement_velocity.y)
	#Changes direction based on the input values. Normalized means it turns any value, no matter how large, to a 0-1 value. This makes movement speed more consistant
	direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
	
	#If the player is pressing a movement key, gain velocity in that direction
	if direction:
		current_velocity = lerp(current_velocity, Vector2(direction.x, direction.z) * speed, acceleration)
	#If player is NOT pressing anything, slow the player down to 0 velocity in all directions
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, deceleration)
	
	#Sets movement velocity for next frame
	_movement_velocity = Vector3(current_velocity.x, velocity.y, current_velocity.y)
	#Sets velocity
	velocity = _movement_velocity
	
	#Function used for godot to know that this is a physical object that will be moving and colliding with things
	move_and_slide()

#called any time an input is used (Keyboard, mouse)
func _input(event: InputEvent) -> void:
	#If debug is enabled, any of these can be called
	if debug:
		if Input.is_action_just_pressed("gmode"):
			can_fly = !can_fly
			clipping = !clipping
		if Input.is_action_just_pressed("light"):
			light.visible = !light.visible
		#these move the player up and down while in god mode
		if Input.is_action_pressed("jump"):
			if can_fly:
				global_position.y += .5
		if Input.is_action_pressed("crouch"):
			if can_fly:
				global_position.y -= .1
	

func update_rotation(rotation_input) -> void:
	global_transform.basis = Basis.from_euler(rotation_input)
