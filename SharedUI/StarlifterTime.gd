extends Panel

var has_starlifter : bool = false
var star_is_tier_3 : bool = false

var progress_count = 0

@onready var progressBar = $ProgressBar

func _ready():
	EventBus.connect( 'constructed' , Callable( self , "_on_constructed") )
	EventBus.connect( 'star_transitioned' , Callable( self , "_on_star_transitioned" ) )

func _on_tick() -> void:
	progress_count += 1
	progressBar.set_value( progress_count )
	
	if( progress_count >= 30 ):
		EventBus.emit_signal("game_won")

func _on_danger_count( count ) -> void:
	progress_count = 0
	progressBar.set_value( progress_count )

func _on_constructed( building ) -> void:
	if( building.type != Constants.BUILDING_STARLIFTER ):
		return
	
	has_starlifter = true
	test_start_countdown()
	
func _on_star_transitioned( tier ) -> void:
	if( tier != Constants.Tiers.TIER_3 ):
		return
	
	star_is_tier_3 = true
	test_start_countdown()
	
func test_start_countdown() -> void:
	if( has_starlifter && star_is_tier_3 ):
		start_countdown()

func start_countdown():
	show()
	
	EventBus.connect('danger_count' , Callable( self , "_on_danger_count" ) )
	EventBus.connect('tick' , Callable( self , "_on_tick") )
