extends KinematicBody2D

var train_running = false
var cur_speed = 0.0
var accel_rate = 0.5
var player = null

func _ready():
	$BoardTrainArea.connect("body_entered", self, "on_body_enter")

func on_body_enter(body: PhysicsBody2D):
	if train_running:
		return
	if body.is_in_group("player") and body.board_train():
		start_train()
		player = body

func start_train():
	$SmokeStack/SmokeParticles.emitting = true
	train_running = true

func _physics_process(delta):
	if !train_running:
		return
	$AnimationPlayer.play("run", cur_speed / 20.0)
	cur_speed += accel_rate * delta
	var coll = move_and_collide(Vector2.LEFT * cur_speed)
	if coll and coll.collider.has_method("hurt"):
		coll.collider.hurt(100, Vector2.LEFT)
	player.global_position = global_position
	if global_position.x < -300:
		print('load next level')