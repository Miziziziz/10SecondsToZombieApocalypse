extends KinematicBody2D

onready var health_manager = $HealthManager
onready var character_mover = $CharacterMover
onready var animation_manager = $Graphics/AnimationManager

onready var nav : Navigation2D = get_parent()

enum STATES {IDLE, CHASING, ATTACKING, DEAD}
var cur_state = STATES.IDLE

var player : KinematicBody2D

var min_attack_range = 11
var max_attack_range = 20

signal attacked
signal alerted
signal dead

func _ready():
	health_manager.connect("dead", self, "kill")
	health_manager.connect("dead", animation_manager, "kill")
	character_mover.connect("velocity_updated", animation_manager, "update_velocity")
	character_mover.init(self)
	health_manager.init()
	player = get_tree().get_nodes_in_group("player")[0]

func _process(delta):
	match cur_state:
		STATES.IDLE:
			process_idle_state(delta)
		STATES.CHASING:
			process_chase_state(delta)

func set_state_chase():
	cur_state = STATES.CHASING

func process_idle_state(_delta):
	if has_line_of_sight(player.global_position):
		emit_signal("alerted")
		cur_state = STATES.CHASING

func process_chase_state(_delta):
	var path = nav.get_simple_path(global_position, player.global_position)
	if path.size() > 1:
		character_mover.set_move_vec(path[1] - global_position)
	if in_min_attack_range_of_player():
		start_attack()

func start_attack():
	animation_manager.pause = true
	cur_state = STATES.ATTACKING
	$AttackTimer.start()
	$Graphics/AnimationManager/AnimationPlayer.play("attack")
	character_mover.set_move_vec(Vector2.ZERO)
	emit_signal("attacked")

func finish_attack():
	animation_manager.pause = false
	if cur_state != STATES.DEAD:
		$PauseAfterAttackTimer.start()
		if in_max_attack_range_of_player():
			player.hurt(1, global_position.direction_to(player.global_position))

func set_chase_state():
	if cur_state != STATES.DEAD:
		cur_state = STATES.CHASING

func in_min_attack_range_of_player():
	return global_position.distance_squared_to(player.global_position) < min_attack_range * min_attack_range

func in_max_attack_range_of_player():
	return global_position.distance_squared_to(player.global_position) < max_attack_range * max_attack_range

func has_line_of_sight(end_pos: Vector2):
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, end_pos, [], 1)
	if result: # hit a wall
		return false
	return true

var give_points_on_kill=true
func hurt(damage, dir=Vector2.ZERO):
	health_manager.hurt(damage, dir)

func kill():
	cur_state = STATES.DEAD
	$CollisionShape2D.call_deferred("set_disabled", true)
	character_mover.set_move_vec(Vector2.ZERO)
	character_mover.dead = true
	if give_points_on_kill:
		player.add_points(1)
	$Graphics/AnimationManager/MoveCPUParticles2D.emitting = false
	$HitBox.deactivate()
	emit_signal("dead")

func get_move_vec():
	return character_mover.move_vec
