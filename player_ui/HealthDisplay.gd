extends GridContainer

var heart_full = preload("res://assets/ui/heart_full.png")
var heart_empty = preload("res://assets/ui/heart_empty.png")
const MAX_HEALTH = 10

func update_health(cur_health: int, max_health: int):
	if max_health > 10:
		max_health = MAX_HEALTH
	for i in range(MAX_HEALTH):
		var heart_node = get_child(i)
		if i < max_health:
			heart_node.show()
		else:
			heart_node.hide()
		if i < cur_health:
			heart_node.texture = heart_full
		else:
			heart_node.texture = heart_empty
		
