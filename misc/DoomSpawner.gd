extends Node2D

var super_zombie_obj = preload("res://characters/SuperZombie.tscn")
onready var spawn_points = $SpawnPoints.get_children()
var nav : Navigation2D

func _ready():
	nav = get_tree().get_nodes_in_group("navigation")[0]

func start_spawning():
	#$SpawnTimer.start()
	$StartSound.play()
	spawn()

var zombie_count = 0
var zombie_killed_count = 0
func spawn():
	for spawn_point in spawn_points:
		var super_zombie_inst = super_zombie_obj.instance()
		nav.add_child(super_zombie_inst)
		super_zombie_inst.global_position = spawn_point.global_position
		super_zombie_inst.set_chase_state()
		super_zombie_inst.connect("dead", self, "add_zombie_kill")
		zombie_count += 1

func add_zombie_kill():
	zombie_killed_count += 1
	if zombie_killed_count == zombie_count:
		$LoadNextLevelTimer.start()

func go_to_next_level():
	LevelManager.load_next_level(false)
