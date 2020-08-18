extends Label

signal out_of_time

var time_left = 10
export var activated = true

func start():
	if !activated:
		return
	$Timer.start()
	$ClockSoundTimer.start()
	$ClockSounds.play()
	update_display()

func decrement_time():
	if time_left <= 0:
		return
	time_left -= 1
	if time_left == 3:
		$ClockSoundTimer.wait_time = 0.5
	if time_left <= 0:
		$ClockSoundTimer.stop()
		time_left = 0
		get_tree().call_group("doom_spawner", "start_spawning")
		emit_signal("out_of_time")
	update_display()

func update_display():
	if time_left == 0:
		text = "RUN"
	else:
		text = "Time Left: " + str(time_left)
