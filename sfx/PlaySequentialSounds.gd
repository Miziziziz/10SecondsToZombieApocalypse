extends Node2D

export var vol = 1.0

export var autostart = false
func _ready():
	for child in get_children():
		child.volume_db = linear2db(vol)
	if autostart:
		for child in get_children():
			child.connect("finished", self, "play")
		play()

var ind = 0
func play():
	get_child(ind).play()
	ind += 1
	ind %= get_child_count()
