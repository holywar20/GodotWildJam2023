extends ColorRect

const MOVEMENT_MULTIPLYIER = 0.002
var bg_material : ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	bg_material = get_material()
	EventBus.connect( 'camera_moved' , Callable( self , "_on_camera_moved") )

func _on_camera_moved( g_pos : Vector2 ) -> void:
	bg_material.set_shader_parameter( 'posOffset' , g_pos * MOVEMENT_MULTIPLYIER )
