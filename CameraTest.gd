extends Camera2D

const CAM_SPEEED = 500

func _process(delta):
	var movement_vector = Vector2(
		Input.get_action_strength("CAMERA_EAST") - Input.get_action_strength("CAMERA_WEST"),
		Input.get_action_strength("CAMERA_SOUTH") - Input.get_action_strength("CAMERA_NORTH")
	).normalized()

	move_camera(movement_vector)

func move_camera(direction):
	global_position += direction * CAM_SPEEED * get_process_delta_time()
	EventBus.emit_signal('camera_moved' , global_position )
	# Limit the camera movement within your game boundaries if needed
	# Example: global_position = global_position.clamped(game_area_rect.position, game_area_rect.end)
