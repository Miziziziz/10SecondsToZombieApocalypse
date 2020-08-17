extends Node2D


var min_wait_time = 0.0001
var max_wait_time = 0.1

var min_scale = .5
var max_scale = 1.5

func _ready():
	hide()
	var sc = rand_range(min_scale, max_scale)
	scale = Vector2(sc, sc)
	$Timer.wait_time = rand_range(min_wait_time, max_wait_time)
	$Timer.start()
