extends PanelContainer


const MESSAGE_MAX_CRACKERS_REACHED = "Maximum number of crackers for this planet reached!"


@onready var cracker_controls = $VBoxContainer/CrackerControls
@onready var hydrogen_slider_control = cracker_controls.get_node("HydrogenSliderControl")
@onready var base_metals_slider_control = cracker_controls.get_node("BaseMetalsSliderControl")
@onready var precious_metals_slider_control = cracker_controls.get_node("PreciousMetalsSliderControl")

@onready var baseCost = $VBoxContainer/BuyCracker/Buy/HBoxContainer/Base


var _current_planet: Planet = null
var _planet_view_init_phase: bool = false

var buildingInfoArray = Info.BUILDING_INFO
var crackerInfo

func _ready():
	EventBus.constructed.connect(_on_constructed)
	EventBus.planet_selected.connect(_on_planet_selected)
	EventBus.construction_started.connect(_on_construction_started)
	EventBus.camera_move_to_planet_finished.connect(_on_camera_move_to_planet_finished)

	hydrogen_slider_control.slider.value_changed.connect(_on_hydrogen_value_changed)
	base_metals_slider_control.slider.value_changed.connect(_on_base_metals_value_changed)
	precious_metals_slider_control.slider.value_changed.connect(_on_precious_metals_value_changed)
	
	for itemScene in buildingInfoArray:
		if itemScene.type == Constants.BUILDING_PLANET_CRACKER:
			crackerInfo = itemScene
			break


# TODO: See if planetRef is necessary; if _current_planet is already set beforehand, then it's safe
# to remove the parameter to updateUI here.
func updateUI(planetRef: Planet):
	if planetRef.has_planet_crackers():
		cracker_controls.show()
		hydrogen_slider_control.set_init_value(planetRef.get_hydrogen_percentage())
		base_metals_slider_control.set_init_value(planetRef.get_base_metals_percentage())
		precious_metals_slider_control.set_init_value(planetRef.get_precious_metals_percentage())
	else:
		cracker_controls.hide()


func _on_buy_pressed():
	if not _current_planet:
		return

	if not _current_planet.has_room_for_crackers():
		EventBus.feedback_message.emit(MESSAGE_MAX_CRACKERS_REACHED)

	EventBus.construction_requested.emit(Constants.BUILDING_PLANET_CRACKER)


func _on_constructed(building) -> void:
	if building.type != Constants.BUILDING_PLANET_CRACKER or _current_planet != building.get_assigned_planet():
		return

	_populate_resource_sliders()

	cracker_controls.modulate = Color.TRANSPARENT
	cracker_controls.show()
	create_tween().tween_property(cracker_controls, "modulate", Color.WHITE, 0.25)


func _on_planet_selected(planet) -> void:
	_current_planet = planet
	baseCost.text = str(crackerInfo.building_costs[Constants.BASE_METAL])


func _on_construction_started(building) -> void:
	if building.type == Constants.BUILDING_PLANET_CRACKER:
		building.assign_to(_current_planet)


func _on_camera_move_to_planet_finished() -> void:
	if _current_planet.has_planet_crackers():
		_populate_resource_sliders()
		cracker_controls.show()


func _populate_resource_sliders() -> void:
	_planet_view_init_phase = true

	#if _current_planet.get_hydrogen_percentage() == 0:
		#hydrogen_slider_control.
	hydrogen_slider_control.set_init_value(_current_planet.get_hydrogen_percentage())
	base_metals_slider_control.set_init_value(_current_planet.get_base_metals_percentage())
	precious_metals_slider_control.set_init_value(_current_planet.get_precious_metals_percentage())

	_planet_view_init_phase = false


func normalizeSliders(value, changeSlider):
	if _planet_view_init_phase:
		return

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
