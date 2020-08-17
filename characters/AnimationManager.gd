extends Node2D

var dead = false

onready var anim_player = $AnimationPlayer
onready var move_particles = $MoveCPUParticles2D

var pause = false

func update_velocity(velocity: Vector2):
	if dead or pause:
		move_particles.emitting = false
		return
	var velo_len = velocity.length()
	if velo_len < 30.0:
		anim_player.play("idle", 0.05)
		move_particles.emitting = false
	else:
		anim_player.play("run", 0.05, velo_len / 100.0)
		move_particles.emitting = true

func kill():
	anim_player.play("die")
	dead = true
