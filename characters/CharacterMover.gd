extends Node2D

var body : KinematicBody2D
var move_vec : Vector2

export var max_speed = 200.0
export var accel = 50.0

var drag = 0.0
var velocity : Vector2

signal velocity_updated

func _ready():
	drag = accel / max_speed

func init(_body: KinematicBody2D):
	body = _body

func set_move_vec(_move_vec: Vector2):
	move_vec = _move_vec.normalized()

func _physics_process(_delta):
	if !body:
		return
	
	velocity += move_vec * accel - velocity * drag
	body.move_and_slide(velocity)
	emit_signal("velocity_updated", velocity)
