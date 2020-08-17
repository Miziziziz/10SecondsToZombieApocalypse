extends KinematicBody2D

onready var health_manager = $HealthManager
onready var character_mover = $CharacterMover
onready var animation_manager = $Graphics/AnimationManager
onready var weapon_manager = $WeaponManager
onready var pickup_manager = $PickupManager
onready var timer = $CanvasLayer/TimerDisplay
onready var stats_display = $CanvasLayer/StatsDisplay
var dead = false
var boarded_train = false

onready var start_position = global_position
var started = false

func _ready():
	health_manager.connect("dead", self, "kill")
	health_manager.connect("dead", animation_manager, "kill")
	health_manager.connect("dead", weapon_manager, "kill")
	character_mover.connect("velocity_updated", animation_manager, "update_velocity")
	pickup_manager.connect("picked_up_fuel", stats_display, "add_fuel")
	pickup_manager.connect("picked_up_weapon", weapon_manager, "pickup_weapon")
	
	weapon_manager.connect("weapons_updated", $CanvasLayer/WeaponsHeld, "update_weapons_held")
	health_manager.connect("health_updated", $CanvasLayer/HealthDisplay, "update_health")
	
	character_mover.init(self)
	health_manager.init()

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	
	
	if Input.is_action_just_pressed("restart"):
		get_tree().call_group("instance", "queue_free")
		get_tree().reload_current_scene()
	if boarded_train:
		return
	if dead:
		return
	
	if !started and global_position.distance_to(start_position) > 20:
		started = true
		timer.start()
	
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec += Vector2.UP
	if Input.is_action_pressed("move_down"):
		move_vec += Vector2.DOWN
	if Input.is_action_pressed("move_right"):
		move_vec += Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		move_vec += Vector2.LEFT
	character_mover.set_move_vec(move_vec)

func hurt(damage, dir=Vector2.ZERO):
	if boarded_train:
		return
	health_manager.hurt(damage, dir)

func kill():
	character_mover.dead = true
	dead = true

func board_train():
	if stats_display.total_fuel == stats_display.fuel_count:
		character_mover.dead = true
		boarded_train = true
		hide()
		$CollisionShape2D.call_deferred("set_disabled", true)
		return true
	return false
	

func add_points(num_of_points: int):
	$CanvasLayer/StatsDisplay.add_points(num_of_points)
