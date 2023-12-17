extends Panel


func _ready():
	EventBus.connect( "game_won" , Callable( self , "_on_game_won" ) )


func _on_game_won():
	EventBus.game_paused.emit( false )
	show()
