extends Panel


@onready var label = $Label
const DANGER_FSTRING = "Flow out of Tolerance ... %s seconds to catastrophe!"

var failState

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("danger_count" , Callable( self, "_on_danger_count" ) )
	EventBus.game_restart.connect(_on_game_restart)

func _on_danger_count( danger_count : int , dir ) -> void:
	if( danger_count == 10 ):
		EventBus.emit_signal( "danger_fail", dir )
		return
	
	if (danger_count == 0):
		hide()
		return
	
	AudioManager.play_sfx("DANGER_WARNING")
	show()
	label.text = DANGER_FSTRING % ( Constants.DANGER_TIME - danger_count )

	# Must be greater than danger time.
	# IE - people can still save themselves at 0
	if( danger_count > Constants.DANGER_TIME ):
		EventBus.emit_signal( "danger_fail", dir )

func _on_game_restart() -> void:
	hide()
