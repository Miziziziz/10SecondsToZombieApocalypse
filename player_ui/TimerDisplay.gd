extends Label

signal out_of_time

var time_left = 10

func _ready():
	update_display()

func decrement_time():
	if time_left <= 0:
		return
	time_left -= 1
	if time_left <= 0:
		time_left = 0
		emit_signal("out_of_time")
	update_display()

func update_display():
	if time_left == 0:
		text = "RUN"
	else:
		text = "Time Left: " + str(time_left)
