extends PanelContainer


@onready var cracker_controls = $VBoxContainer/CrackerControls
@onready var hydrogen_slider_control = cracker_controls.get_node("HydrogenSliderControl")
@onready var base_metals_slider_control = cracker_controls.get_node("BaseMetalsSliderControl")
@onready var precious_metals_slider_control = cracker_controls.get_node("PreciousMetalsSliderControl")


var _current_planet: Planet = null


func _ready():
	EventBus.constructed.connect(_on_constructed)
	EventBus.planet_selected.connect(_on_planet_selected)
	EventBus.construction_started.connect(_on_construction_started)
	EventBus.camera_move_to_planet_finished.connect(_on_camera_move_to_planet_finished)

	hydrogen_slider_control.slider.value_changed.connect(_on_hydrogen_value_changed)
	base_metals_slider_control.slider.value_changed.connect(_on_base_metals_value_changed)
	precious_metals_slider_control.slider.value_changed.connect(_on_precious_metals_value_changed)


func _on_buy_pressed():
	if not _current_planet:
		return

	EventBus.construction_requested.emit(Constants.BUILDING_PLANET_CRACKER)


func _on_constructed(building) -> void:
	if not building.type == Constants.BUILDING_PLANET_CRACKER:
		return

	_populate_resource_sliders()
	cracker_controls.show()


func _on_planet_selected(planet) -> void:
	_current_planet = planet


func _on_construction_started(building) -> void:
	if building.type == Constants.BUILDING_PLANET_CRACKER:
		building.assign_to(_current_planet)


func _on_camera_move_to_planet_finished() -> void:
	if _current_planet.has_planet_crackers():
		_populate_resource_sliders()
		cracker_controls.show()


func _populate_resource_sliders() -> void:
	hydrogen_slider_control.set_init_value(_current_planet.get_hydrogen_percentage())
	base_metals_slider_control.set_init_value(_current_planet.get_base_metals_percentage())
	precious_metals_slider_control.set_init_value(_current_planet.get_precious_metals_percentage())


func normalizeSliders(value, changeSlider):
	var hydro = hydrogen_slider_control.slider
	var base = base_metals_slider_control.slider
	var precious = precious_metals_slider_control.slider
	
	var sliders = [hydro,base,precious]
	
	var total = hydro.value + base.value + precious.value
	
	var movingSliderIndex
	var highestSliderIndex = 0
	var highestSliderValue = -1
	
	
	for x in range(sliders.size()):
		if sliders[x] == changeSlider:
			movingSliderIndex = x
			break
	
	
	for x in range(sliders.size()):
		total += sliders[x].value
		if sliders[x].value > highestSliderValue and x != movingSliderIndex:
			highestSliderValue = sliders[x].value
			highestSliderIndex = x
	
	var excess = total - 2
	
	# If total exceeds 100, deduct the excess from the slider with the highest value
	if total > 2:
		sliders[highestSliderIndex].value -= excess
	
	_current_planet.set_hydrogen_percentage(hydro.value)
	_current_planet.set_base_metals_percentage(base.value)
	_current_planet.set_precious_metals_percentage(precious.value)


func _on_hydrogen_value_changed(value: float) -> void:
	if not _current_planet:
		return
	normalizeSliders(value, hydrogen_slider_control.slider)


func _on_base_metals_value_changed(value: float) -> void:
	if not _current_planet:
		return
	normalizeSliders(value, base_metals_slider_control.slider)


func _on_precious_metals_value_changed(value: float) -> void:
	if not _current_planet:
		return
	normalizeSliders(value, precious_metals_slider_control.slider)
