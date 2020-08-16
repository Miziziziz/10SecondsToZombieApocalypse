extends Area2D

signal picked_up_fuel
signal picked_up_weapon

func _process(_delta):
	var areas = get_overlapping_areas()
	for area in areas:
		if "Fuel" in area.name:
			emit_signal("picked_up_fuel")
			area.queue_free()
		elif area is Weapon:
			emit_signal("picked_up_weapon", area)
