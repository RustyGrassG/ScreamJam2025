class_name CameraController extends Node3D

#Export variables for the Camera

#Toggles any debug code
@export var debug : bool = false
@export_category("References")
#References the main player node
@export var player_controller : PlayerController
#References the mouse capture node/class
@export var component_mouse_capture : MouseCaptureComponent
@export_category("Camera Settings")
@export_group("Camera Tilt")
#The Tilt range(Up/down) of the FPS camera in degrees
@export_range(-90,-60) var tilt_lower_limit : int = -90
@export_range(60,90) var tilt_upper_limit : int = 90

#Player Rotation. Holds the rotation value. This is seperate from the nodes rotation value, but will be applied to it later
var _rotation : Vector3

#Updates the cameras rotation. Uses thje mouse movement to determine new rotation
func update_camera_rotation(input: Vector2) -> void:
	#Updates the rotation value
	_rotation.x += input.y
	_rotation.y += input.x
	#Clamps the value between the 2 exported tilt ranges
	_rotation.x = clamp(_rotation.x, deg_to_rad(tilt_lower_limit), deg_to_rad(tilt_upper_limit))
	
	#Creates two variables to seperate player rotation from camera rotation(Keeps player moving in line with the camera rotation)
	var _player_rotation = Vector3(0.0, _rotation.y,0.0)
	var _camera_rotation = Vector3(_rotation.x, 0.0, 0.0)
	
	#references the camera node and Updates camera rotation
	transform.basis = Basis.from_euler(_camera_rotation)
	#Updates player rotation
	#references the player node and Updates player rotation
	player_controller.update_rotation(_player_rotation)
	
	#Resets Z rotation. Do not want the camera to rotate on the z-axis at all, so this just double checks it
	_rotation.z = 0
