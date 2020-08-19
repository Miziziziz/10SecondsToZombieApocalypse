extends KinematicBody2D

func hurt(damage, dir=Vector2.ZERO):
	get_parent().hurt(damage, dir)

func deactivate():
	$CollisionShape2D.call_deferred("set_disabled", true)

func set_give_points_on_kill(b: bool):
	get_parent().give_points_on_kill = b
