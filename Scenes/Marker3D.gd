extends Marker3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var in_v = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	global_position += Vector3(in_v.x, in_v.y, 0) * delta * 2
