class_name MouseCaptureComponent extends Node
#Toggles debug code
@export var debug : bool = false
@export_category("Mouse Capture Settings")
#Sets mouse mode to capture(Meaning the mouse is hidden and resets to the center of the screen every update
@export var current_mouse_mode : Input.MouseMode = Input.MOUSE_MODE_CAPTURED
#Mouse sensitivity
@export var mouse_sensitivity : float = 0.005
@export_category("Data")
#References the camera controller node/script
@export var camera_controller : CameraController

#Used for the function below
var _capture_mouse : bool
var _mouse_input : Vector2

#any time an input(key press, mouse movement) happens, this function is called
func _unhandled_input(event: InputEvent) -> void:
	#variable that stores a boolean(true or false) value. checks if mouse is captured and the mouse is the input event that called this function
	_capture_mouse = event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	#if the mouse is captured and the input event is a mouse input event, rotate the camera by x amount(How far and fast the mouse moved from the center point of the screen)
	if _capture_mouse:
		_mouse_input.x += -event.screen_relative.x * mouse_sensitivity
		_mouse_input.y += -event.screen_relative.y * mouse_sensitivity
		camera_controller.update_camera_rotation(_mouse_input)
	#If debug is enabled, print this to log
	if debug:
		print(_mouse_input)

#When node loads, set mouse to captured mouse
func _ready() -> void:
	Input.mouse_mode = current_mouse_mode

#Resets mouse input to zero every process frame
func _process(delta: float) -> void:
	_mouse_input = Vector2.ZERO
