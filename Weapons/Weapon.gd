extends Area2D

class_name Weapon

onready var anim_player = $AnimationPlayer

signal done_shooting

var is_shooting = false

export var wep_name = ""

func shoot():
	if is_shooting:
		return
	is_shooting = true
	anim_player.play("shoot")

func finished_shooting():
	emit_signal("done_shooting")

func pickup():
	$CollisionShape2D.call_deferred("set_disabled", true)

func destroy():
	$DeleteTimer.start() # use timer so sound effect won't get cut off
	hide()
