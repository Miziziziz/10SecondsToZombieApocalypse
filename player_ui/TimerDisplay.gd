extends Label

signal out_of_time

var time_left = 10
export var activated = true
export var out_of_time_text = "RUN"
func _ready():
	text = "Level " + str(LevelManager.get_current_level()) + "/" + str(LevelManager.get_number_of_levels())

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
		text = out_of_time_text
	else:
		text = "Time Left: " + str(time_left)
