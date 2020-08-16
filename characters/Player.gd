extends KinematicBody2D

onready var health_manager = $HealthManager
onready var character_mover = $CharacterMover
onready var animation_manager = $Graphics/AnimationManager
onready var weapon_manager = $WeaponManager
onready var pickup_manager = $PickupManager

var dead = false

func _ready():
	health_manager.connect("dead", self, "kill")
	health_manager.connect("dead", animation_manager, "kill")
	health_manager.connect("dead", weapon_manager, "kill")
	character_mover.connect("velocity_updated", animation_manager, "update_velocity")
	pickup_manager.connect("picked_up_fuel", $CanvasLayer/StatsDisplay, "add_fuel")
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
	
	if dead:
		return
	
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
	health_manager.hurt(damage, dir)

func kill():
	character_mover.set_move_vec(Vector2.ZERO)
	dead = true

func add_points(num_of_points: int):
	$CanvasLayer/StatsDisplay.add_points(num_of_points)
