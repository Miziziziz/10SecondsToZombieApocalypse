extends Node2D

onready var points_label = $CanvasLayer/UpgradeScreen/PointsLeft

onready var upgrade_health_button = $CanvasLayer/UpgradeScreen/GridContainer/UpgradeHealth
onready var upgrade_speed_button = $CanvasLayer/UpgradeScreen/GridContainer/UpgradeSpeed
onready var add_weapon_slot_button = $CanvasLayer/UpgradeScreen/GridContainer/AddWeaponSlot

func _ready():
	upgrade_health_button.connect("button_up", self, "upgrade_health")
	upgrade_speed_button.connect("button_up", self, "upgrade_speed")
	add_weapon_slot_button.connect("button_up", self, "add_weapon_slot")
	$CanvasLayer/UpgradeScreen/ContinueButton.connect("button_up", self, "continue_to_next_level")
	update_display()

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		LevelManager.load_main_menu()

func update_display():
	points_label.text = "Points Available: " + str(StatsManager.points)
	
	var stat_max = StatsManager.STAT_MAX
	var cur_hp = StatsManager.player_health
	var cur_speed = StatsManager.player_speed
	var cur_slots = StatsManager.player_weapon_slots
	if cur_hp == stat_max:
		upgrade_health_button.disabled = true
	if cur_speed == stat_max:
		upgrade_speed_button.disabled = true
	if cur_slots == stat_max:
		add_weapon_slot_button.disabled = true
	upgrade_health_button.get_node("CurrentStat").text = "Health: " + str(cur_hp)
	upgrade_speed_button.get_node("CurrentStat").text = "Speed: " + str(cur_speed)
	add_weapon_slot_button.get_node("CurrentStat").text = "Slots: " + str(cur_slots)
	upgrade_health_button.get_node("CostLabel").text = "Cost: " + str(StatsManager.get_upgrade_cost_health())
	upgrade_speed_button.get_node("CostLabel").text = "Cost: " + str(StatsManager.get_upgrade_cost_speed())
	add_weapon_slot_button.get_node("CostLabel").text = "Cost: " + str(StatsManager.get_upgrade_cost_slots())

func upgrade_health():
	if StatsManager.upgrade_health():
		update_display()

func upgrade_speed():
	if StatsManager.upgrade_speed():
		update_display()

func add_weapon_slot():
	if StatsManager.add_weapon_slot():
		update_display()

func get_upgrade_cost(stat_level: int):
	return stat_level * 2

func continue_to_next_level():
	LevelManager.load_next_level()
