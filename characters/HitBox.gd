extends Area2D


func hurt(damage, dir=Vector2.ZERO):
	get_parent().hurt(damage, dir)
