extends Area2D

var active = false

func _ready():
	connect("body_entered", self, "on_body_enter")

func on_body_enter(body):
	if !active:
		return
	if body.has_method("set_give_points_on_kill"):
		body.set_give_points_on_kill(false)
	body.hurt(100, Vector2.LEFT)
