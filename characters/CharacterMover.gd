extends Node2D

var body : KinematicBody2D
var move_vec : Vector2

export var max_speed = 200.0
export var accel = 50.0

var drag = 0.0
var velocity : Vector2

signal velocity_updated

var zombie_attractor : Area2D
var zombie_repeller : Area2D
export var alignment_amount = .5
export var cohesion_amount = 0.05
export var repel_amount = 0.1

var dead = false

func _ready():
	update_drag()
	if has_node("ZombieAttractor"):
		zombie_attractor = $ZombieAttractor
	if has_node("ZombieRepeller"):
		zombie_repeller = $ZombieRepeller

func set_speed(sp: int):
	max_speed = 20 * sp + 80
	update_drag()

func update_drag():
	drag = accel / max_speed

func init(_body: KinematicBody2D):
	body = _body

func set_move_vec(_move_vec: Vector2):
	move_vec = _move_vec.normalized()

func increase_speed():
	max_speed += 1
	update_drag()

func _physics_process(_delta):
	if !body or dead:
		return
	
	velocity += move_vec * accel - velocity * drag
	if zombie_attractor != null and zombie_repeller != null:
		do_flocking_stuff()
	else:
		body.move_and_slide(velocity)
	emit_signal("velocity_updated", velocity)


func do_flocking_stuff():
	var zombies_to_attract = zombie_attractor.get_overlapping_bodies()
	var zombies_to_repel = zombie_repeller.get_overlapping_bodies()
	
	if zombies_to_attract.size() > 0:
		var avg_heading = Vector2.ZERO
		var avg_pos = Vector2.ZERO
		for zombie in zombies_to_attract:
			avg_heading += zombie.get_move_vec()
			avg_pos += zombie.global_position
		avg_heading /= zombies_to_attract.size()
		avg_pos /= zombies_to_attract.size()
		var cohesion_dir = global_position.direction_to(avg_pos)
		move_vec = move_vec * (1.0 - alignment_amount) + avg_heading * alignment_amount 
		move_vec = move_vec * (1.0 - cohesion_amount) + cohesion_dir * cohesion_amount 
	
	if zombies_to_repel.size() > 0:
		var repel_vec = Vector2()
		for zombie in zombies_to_repel:
			repel_vec += zombie.global_position.direction_to(global_position)
		repel_vec /= zombies_to_repel.size()
		move_vec = move_vec * (1.0 - repel_amount) + repel_vec * repel_amount 
	
	velocity += accel * move_vec - velocity * drag
	velocity = body.move_and_slide(velocity, Vector2.ZERO)
