extends KinematicBody2D

var train_running = false
var cur_speed = 0.0
var accel_rate = 0.5
var player = null

export var visual_only = false

func _ready():
	$BoardTrainArea.hide()
	var player_objs = get_tree().get_nodes_in_group("player")
	if player_objs.size() > 0:
		player_objs[0].connect("collected_all_fuel", self, "start_flashing")
	$BoardTrainArea.connect("body_entered", self, "on_body_enter")
	if visual_only:
		$SmokeStack/SmokeParticlesFakeMovement.emitting = true
		$AnimationPlayer.play("run")
		$TrainLoopSound.play()
		#$TrainLoopSound/AnimationPlayer.play("fadein")

func start_flashing():
	$BoardTrainArea/AnimationPlayer.play("flash")
	$BoardTrainArea.show()

func on_body_enter(body: PhysicsBody2D):
	if train_running:
		return
	if body.is_in_group("player") and body.board_train():
		start_train()
		player = body

func start_train():
	$BoardTrainArea.hide()
	$SmokeStack/SmokeParticles.emitting = true
	train_running = true
	$TrainStartSound.play()

func _physics_process(delta):
	if !train_running:
		return
	$AnimationPlayer.play("run", cur_speed / 20.0)
	cur_speed += accel_rate * delta
	var coll = move_and_collide(Vector2.LEFT * cur_speed)
	if coll and coll.collider.has_method("hurt") and "give_points_on_kill" in coll.collider:
		coll.collider.set("give_points_on_kill", false)
		coll.collider.hurt(100, Vector2.LEFT)
	player.global_position = global_position
	if global_position.x < -300:
		StatsManager.save_player_weapons(player)
		StatsManager.points += player.gets_points_gained_this_session()
		LevelManager.load_next_level()
