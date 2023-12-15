class_name MagneticBore
extends AbstractBuilding


var extraction_rate: float = 1.0:
	set = set_extraction_rate

var _gas_clouds: Array = []


func _on_button_pressed():
	EventBus.emit_signal("building_pressed", Constants.BUILDING_MAGNETIC_BORE)


func set_extraction_rate(value: float) -> void:
	extraction_rate = value


func next_extraction():
	produces = {
		Constants.HYDROGEN: 0
	}

	# randomly select which cloud is being pulled from for this extraction
	var clouds_remaining = _gas_clouds.filter(func (c): return c.has_hydrogen_remaining())

	if not clouds_remaining:
		return produces

	var cloud = clouds_remaining[randi_range(0, clouds_remaining.size() - 1)]
	produces[Constants.HYDROGEN] += cloud.extract_hydrogen(extraction_rate)

	return produces


func set_gas_clouds(value: Array) -> void:
	_gas_clouds = value


func post_constructed() -> void:
	EventBus.magnetic_bore_constructed.emit(self)
