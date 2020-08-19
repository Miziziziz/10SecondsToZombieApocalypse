extends Node

const STAT_MAX = 9

var player_health = 5
var player_speed = 9
var player_weapon_slots = 5
var points = 0

func upgrade_speed():
	if player_speed < STAT_MAX and spend_points(get_upgrade_cost_speed()):
		player_speed = clamp(player_speed + 1, 0, STAT_MAX)
		return true
	return false

func upgrade_health():
	if player_health < STAT_MAX and spend_points(get_upgrade_cost_health()):
		player_health = clamp(player_health + 1, 0, STAT_MAX)
		return true
	return false

func add_weapon_slot():
	if player_weapon_slots < STAT_MAX and spend_points(get_upgrade_cost_slots()):
		player_weapon_slots = clamp(player_weapon_slots + 1, 0, STAT_MAX)
		return true
	return false

func get_upgrade_cost_health():
	return get_upgrade_cost(player_health)

func get_upgrade_cost_speed():
	return get_upgrade_cost(player_speed)

func get_upgrade_cost_slots():
	return get_upgrade_cost(player_weapon_slots)

func get_upgrade_cost(stat_level: int):
	return stat_level * 2

var weapon_list = []
func save_player_weapons(player_node):
	weapon_list = player_node.get_weapons_list()

func spend_points(num: int):
	if num <= points:
		points -= num
		return true
	return false

func reset_stats():
	points = 0
	player_health = 1
	player_speed = 1
	player_weapon_slots = 1
	weapon_list = []
