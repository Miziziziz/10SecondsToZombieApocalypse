extends Label

var total_fuel = 0
var fuel_count = 0
var points_count = 0
var points_gained_this_level = 0

func _ready():
	total_fuel = get_tree().get_nodes_in_group("fuel").size()
	update_display()

func add_points(points_to_add: int):
	points_count += points_to_add
	points_gained_this_level += points_to_add
	update_display()

func add_fuel():
	fuel_count += 1
	update_display()

func update_display():
	var s = ""
	s += "Points: " + str(points_count) + "\n"
	s += "Fuel: " + str(fuel_count) + "/" + str(total_fuel)
	text = s
