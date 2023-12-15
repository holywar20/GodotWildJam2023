extends Camera2D


const CAM_SPEED = 1000
const SCREEN_EDGE_TOLERANCE = 10


var _is_mouse_pan: bool = false
var _current_rel: Vector2
var _pan_lock: bool = false
var _movement_vector: Vector2
var _original_cam_pos: Vector2


func _ready() -> void:
	_original_cam_pos = global_position


func _should_pan_lock() -> bool:
	var viewport_rect: Rect2 = get_viewport_rect()
	viewport_rect.position.x += SCREEN_EDGE_TOLERANCE
	viewport_rect.position.y += SCREEN_EDGE_TOLERANCE
	viewport_rect.size.x -= 2 * SCREEN_EDGE_TOLERANCE
	viewport_rect.size.y -= 2 * SCREEN_EDGE_TOLERANCE
	
	var cur_viewport_mouse_pos: Vector2 = get_viewport().get_mouse_position()

	return not viewport_rect.has_point(cur_viewport_mouse_pos)


func _input(event: InputEvent) -> void:
	if _is_mouse_pan:
		if event is InputEventMouseMotion:
			_pan_lock = _should_pan_lock()

			if _pan_lock:
				_movement_vector = _current_rel.normalized()
				return

			_current_rel = (event as InputEventMouseMotion).relative
			_current_rel.y *= -1

			_movement_vector = _current_rel.normalized()


func _process( _delta : float ):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		_is_mouse_pan = true
	elif Input.is_action_just_pressed("CAMERA_RECENTER"):
		global_position = _original_cam_pos
	else:
		_is_mouse_pan = false
		_movement_vector = Vector2(
			Input.get_action_strength("CAMERA_EAST") - Input.get_action_strength("CAMERA_WEST"),
			Input.get_action_strength("CAMERA_SOUTH") - Input.get_action_strength("CAMERA_NORTH")
		).normalized()

	move_camera( _movement_vector )

	if not _pan_lock:
		_movement_vector = Vector2.ZERO


func move_camera(direction):
	global_position += direction * CAM_SPEED * get_process_delta_time()
	EventBus.emit_signal('camera_moved' , global_position )
	# Limit the camera movement within your game boundaries if needed
	# Example: global_position = global_position.clamped( game_area_rect.position , game_area_rect.end )
