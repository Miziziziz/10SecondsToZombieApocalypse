extends Node

var level_list = [
	"res://levels/Intro.tscn",
	"res://levels/Tutorial.tscn",
	"res://levels/WareHouse.tscn",
	"res://levels/LittleTownship.tscn",
	"res://levels/OldFieldHouses.tscn",
	"res://levels/MechanicsStation.tscn",
	
	"res://levels/ShottyIntro.tscn",
	"res://levels/PartyGathering.tscn",
	"res://levels/FirstMiniBoss.tscn",
	"res://levels/Dorms.tscn",
	"res://levels/ToughGuys.tscn",	
	"res://levels/Armories.tscn",
	
	"res://levels/SmgIntro.tscn",
	"res://levels/NotherRedGuy.tscn",
	"res://levels/ThreeRedGuys.tscn",
	"res://levels/MiniHorde.tscn",
	
	"res://levels/BullRush.tscn",
	"res://levels/Mazy.tscn",
	"res://levels/BodyGuards.tscn",
	"res://levels/UtterChaos.tscn",
	"res://levels/FreePoints.tscn",
	"res://levels/FinalBattle.tscn",
	"res://levels/Outro.tscn",
	"res://levels/Credits.tscn"
	
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

func load_next_level(check_for_upgrade_screen=true):
	if cur_level_ind+1 >= level_list.size():
		load_main_menu()
	elif cur_level == "upgrade_screen" or !check_for_upgrade_screen:
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

func get_number_of_levels():
	return level_list.size() - 4

func get_current_level():
	return cur_level_ind - 1
