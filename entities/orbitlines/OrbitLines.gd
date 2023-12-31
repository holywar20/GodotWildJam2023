extends Control

const ARC_POINTS = 64
const ARC_POINT_1 = 0
const ARC_POINT_2 = 180
const ARC_POINT_3 = 360
const ORBIT_SIZE = 2000 # in Pixels
const STAR_SIZE = 1500 # in Pixels
const LINE_WIDTH = 5

const ORBIT_COLOR = Color8( 0 , 200 , 200 , 255 )

const PLANET_COUNT = 6

func _ready():
	queue_redraw()
	
	EventBus.connect('zoom_changed' , Callable( self , "_on_zoom_changed" ) )

func _on_zoom_changed( zoom_level ):
	if( zoom_level.x <= 0.5 ):
		show()
	else:
		hide()

func _draw():
	for x in range( 0 , PLANET_COUNT ):
		var radius = STAR_SIZE + ( ( x + 1 ) * ORBIT_SIZE )
		_drawArc( radius , ARC_POINT_1 , ARC_POINT_2 , ORBIT_COLOR )
		_drawArc( radius , ARC_POINT_2 , ARC_POINT_3 , ORBIT_COLOR )

func _drawArc( radius, angleFrom, angleTo, color ) -> void:
	var points_arc = PackedVector2Array()

	for i in range(ARC_POINTS + 1):
		var anglePoint = deg_to_rad(angleFrom + i * ( angleFrom - angleTo ) / ARC_POINTS - 90)
		var point = Vector2(cos(anglePoint), sin(anglePoint)) * radius
		points_arc.push_back( point )

	for index_point in range(ARC_POINTS):
		draw_line( points_arc[index_point], points_arc[index_point + 1], color , LINE_WIDTH )
