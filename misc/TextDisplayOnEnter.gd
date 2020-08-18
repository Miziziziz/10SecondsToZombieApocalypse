extends Area2D


func _ready():
	connect("body_entered", self, "on_body_enter")
	connect("body_exited", self, "on_body_exit")
	$Label.hide()

func on_body_enter(body):
	if body.is_in_group("player"):
		$Label.show()

func on_body_exit(body):
	if body.is_in_group("player"):
		$Label.hide()
