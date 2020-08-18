extends Label

var total_fuel = 0
var fuel_count = 0
var points_count = 0
var points_gained_this_level = 0

signal collected_all_fuel

func _ready():
	total_fuel = get_tree().get_nodes_in_group("fuel").size()
	update_display()

func add_points(points_to_add: int):
	points_count += points_to_add
	points_gained_this_level += points_to_add
	update_display()

func add_fuel():
	fuel_count += 1
	if fuel_count == total_fuel:
		emit_signal("collected_all_fuel")
	update_display()

func update_display():
	var s = ""
	s += "Points: " + str(points_count) + " "
	s += "Fuel: " + str(fuel_count) + "/" + str(total_fuel)
	text = s
