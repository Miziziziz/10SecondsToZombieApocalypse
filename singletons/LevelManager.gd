extends Node

var level_list = [
	"res://levels/Tutorial.tscn",
	"res://levels/WareHouse.tscn",
	"res://levels/LittleTownship.tscn",
	"res://levels/OldFieldHouses.tscn",
	"res://levels/MechanicsStation.tscn"
]
var cur_level_ind = 0

const main_menu_path = "res://levels/MainMenu.tscn"
const upgrade_screen_path = "res://levels/UpgradeScreen.tscn"

var cur_level = ""

func play_new_game():
	cur_level_ind = 0
	cur_level = "gameplay"
	StatsManager.reset_stats()
	load_game_play_level(cur_level_ind)

func load_next_level():
	if cur_level_ind+1 >= level_list.size():
		load_main_menu()
	elif cur_level == "upgrade_screen":
		cur_level = "gameplay"
		cur_level_ind += 1
		load_game_play_level(cur_level_ind)
	else:
		load_upgrade_screen()

func load_game_play_level(ind):
	$Ambience2.play()
	get_tree().call_group("instance", "queue_free")
	get_tree().change_scene(level_list[ind])

func load_main_menu():
	get_tree().call_group("instance", "queue_free")
	cur_level = "main_menu"
	get_tree().change_scene(main_menu_path)
	$Ambience1.stop()
	$Ambience2.stop()

func load_upgrade_screen():
	get_tree().call_group("instance", "queue_free")
	cur_level = "upgrade_screen"
	get_tree().change_scene(upgrade_screen_path)
	$Ambience1.stop()
	$Ambience2.stop()

