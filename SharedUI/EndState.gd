extends Panel


func _ready():
	EventBus.connect( "game_won" , Callable( self , "_on_game_won" ) )

func _on_game_won():
	EventBus.game_paused.emit( false )
	show()

func _on_button_mouse_entered():
	AudioManager.play_sfx("HOVER_BUTTON")


func _on_button_pressed():
	EventBus.emit_signal("game_restart")
