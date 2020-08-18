extends Node

var level_list = [
	"res://levels/World.tscn",
	"res://levels/World.tscn",
	"res://levels/World.tscn",
	"res://levels/World.tscn",
	"res://levels/World.tscn",
]
var cur_level_ind = 0

const main_menu_path = "res://levels/MainMenu.tscn"
const upgrade_screen_path = "res://levels/UpgradeScreen.tscn"

var cur_level = ""

func play_new_game():
	cur_level_ind = 0
	cur_level = "gameplay"
	StatsManager.reset_stats()
	get_tree().change_scene(level_list[cur_level_ind])

func load_next_level():
	if cur_level_ind+1 >= level_list.size():
		load_main_menu()
	elif cur_level == "upgrade_screen":
		cur_level = "gameplay"
		cur_level_ind += 1
		get_tree().call_group("instance", "queue_free")
		get_tree().change_scene(level_list[cur_level_ind])
	else:
		load_upgrade_screen()

func load_main_menu():
	get_tree().call_group("instance", "queue_free")
	cur_level = "main_menu"
	get_tree().change_scene(main_menu_path)

func load_upgrade_screen():
	get_tree().call_group("instance", "queue_free")
	cur_level = "upgrade_screen"
	get_tree().change_scene(upgrade_screen_path)

