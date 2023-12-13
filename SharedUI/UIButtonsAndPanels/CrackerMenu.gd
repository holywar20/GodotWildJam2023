extends PanelContainer


var _current_planet = null


func _ready():
	EventBus.constructed.connect(_on_constructed)
	EventBus.planet_selected.connect(_on_planet_selected)
	EventBus.construction_started.connect(_on_construction_started) 


func _on_buy_pressed():
	if not _current_planet:
		return

	EventBus.construction_requested.emit(Constants.BUILDING_PLANET_CRACKER)


func _on_constructed(building) -> void:
	if not building.type == Constants.BUILDING_PLANET_CRACKER:
		return

	# TODO: Show slider controls


func _on_planet_selected(planet) -> void:
	_current_planet = planet


func _on_construction_started(building) -> void:
	if building.type == Constants.BUILDING_PLANET_CRACKER:
		building.assign_to(_current_planet)
