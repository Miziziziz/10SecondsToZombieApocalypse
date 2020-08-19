extends KinematicBody2D

onready var health_manager = $HealthManager
onready var character_mover = $CharacterMover
onready var animation_manager = $Graphics/AnimationManager
onready var weapon_manager = $WeaponManager
onready var pickup_manager = $PickupManager
onready var timer = $CanvasLayer/TimerDisplay
onready var stats_display = $CanvasLayer/StatsDisplay
onready var weapons_held_display = $CanvasLayer/WeaponsHeld
var dead = false
var boarded_train = false

onready var start_position = global_position
var started = false

signal collected_all_fuel

func _ready():
	health_manager.max_health = StatsManager.player_health
	health_manager.cur_health = StatsManager.player_health
	character_mover.set_speed(StatsManager.player_speed)
	weapon_manager.total_slots = StatsManager.player_weapon_slots
	weapons_held_display.slots_unlocked = StatsManager.player_weapon_slots
	stats_display.points_count = StatsManager.points
	stats_display.update_display()
	stats_display.connect("collected_all_fuel", self, "emit_collected_all_fuel")
	
	health_manager.connect("dead", self, "kill")
	health_manager.connect("dead", animation_manager, "kill")
	health_manager.connect("dead", weapon_manager, "kill")
	character_mover.connect("velocity_updated", animation_manager, "update_velocity")
	pickup_manager.connect("picked_up_fuel", stats_display, "add_fuel")
	pickup_manager.connect("picked_up_weapon", weapon_manager, "pickup_weapon")
	
	weapon_manager.connect("weapons_updated", weapons_held_display, "update_weapons_held")
	health_manager.connect("health_updated", $CanvasLayer/HealthDisplay, "update_health")
	
	character_mover.init(self)
	health_manager.init()
	weapons_held_display.init()
	load_weapons_list(StatsManager.weapon_list)
	

func _process(_delta):
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
	
	if Input.is_action_just_pressed("shoot"):
		weapon_manager.shoot()

func hurt(damage, dir=Vector2.ZERO):
	if boarded_train:
		return
	health_manager.hurt(damage, dir)

func kill():
	character_mover.dead = true
	dead = true
	$CanvasLayer/RestartMessage.show()

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

func get_weapons_list():
	var l = []
	for weapon in $WeaponManager/Hand.get_children():
		l.append(weapon.wep_name)
	return l

var pistol = preload("res://Weapons/Pistol.tscn")
var shotgun = preload("res://Weapons/Shotgun.tscn")
var smg = preload("res://Weapons/Smg.tscn")

func load_weapons_list(weapon_names: Array):
	for wep_name in weapon_names:
		if wep_name == "shotgun":
			weapon_manager.pickup_weapon(shotgun.instance())
		elif wep_name == "smg":
			weapon_manager.pickup_weapon(smg.instance())
		else:
			weapon_manager.pickup_weapon(pistol.instance())

func gets_points_gained_this_session():
	return stats_display.points_gained_this_level

func emit_collected_all_fuel():
	emit_signal("collected_all_fuel")
