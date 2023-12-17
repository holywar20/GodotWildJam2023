extends Panel

var has_starlifter : bool = false
var star_is_tier_3 : bool = false

func _ready():
	EventBus.connect( 'building_constructed' , Callable( self , "_on_building_constructed") )
	EventBus.connect( 'star_transitioned' , Callable( self , "_on_star_transitioned" ) )

func _on_building_constructed( building ) -> void:
	print( building.type )
	
func _on_star_transitioned( tier ) -> void:
	if( tier != Constants.Tiers.TIER_3 ):
		return
		
	star_is_tier_3 = true
	test_start_countdown()
	
func test_start_countdown() -> void:
	if( has_starlifter && star_is_tier_3 ):
		print("Ready!")
