extends Node2D

export var max_health = 1
onready var cur_health = max_health

onready var blood_spawner = $BloodSpawner

signal hurt
signal dead
signal health_updated

func init():
	emit_signal("health_updated", cur_health, max_health)

func hurt(damage: int, dir=Vector2.ZERO):
	if cur_health == 0:
		return
	cur_health -= damage
	$HurtSounds.play()
	blood_spawner.spray_blood(dir)
	emit_signal("hurt")
	if cur_health <= 0:
		cur_health = 0
		emit_signal("dead")
	emit_signal("health_updated", cur_health, max_health)
