extends ColorRect

const MOVEMENT_MULTIPLYIER = 0.002
var bg_material : ShaderMaterial

var current_zoom : Vector2 = Vector2( 1.0 , 1.0 )

# Called when the node enters the scene tree for the first time.
func _ready():
	bg_material = get_material()
	EventBus.connect( 'camera_moved' , Callable( self , "_on_camera_moved") )
	EventBus.connect( 'zoom_changed' , Callable( self , "_on_zoom_changed") )

func _on_zoom_changed( zoom : Vector2 ) -> void:
	current_zoom = zoom

func _on_camera_moved( g_pos : Vector2 ) -> void:
	# Multiply in the zoom to slow panning/scrolling when in zoomed out
	bg_material.set_shader_parameter( 'posOffset' , g_pos * MOVEMENT_MULTIPLYIER * current_zoom.x )
