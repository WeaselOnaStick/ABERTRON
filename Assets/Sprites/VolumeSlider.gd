extends HSlider

@export var bus_name : StringName

var bus_idx : int

func _ready() -> void:
	min_value = 0
	max_value = 1
	step = 0.01
	bus_idx = AudioServer.get_bus_index(bus_name)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_idx))
	value_changed.connect(func (x) : 
		AudioServer.set_bus_volume_db(bus_idx,linear_to_db(x))
	)
