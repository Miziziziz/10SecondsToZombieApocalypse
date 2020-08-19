extends Node2D

export var vol = 1.0

func _ready():
	for child in get_children():
		child.volume_db = linear2db(vol)

func play():
	if vol == 0.0:
		return
	get_child(randi() % get_child_count()).play()

func stop():
	for child in get_children():
		child.stop()
