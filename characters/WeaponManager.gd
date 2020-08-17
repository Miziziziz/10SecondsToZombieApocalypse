extends Node2D

onready var hand = $Hand

var total_slots = 1
var slots_used = 0
var cur_weapon : Weapon

var dead = false
var flipped = false

signal weapons_updated

func _process(_delta):
	if dead:
		return
	var look_vec = get_global_mouse_position() - global_position
	if look_vec.x < 0 and !flipped:
		flip()
	if look_vec.x >= 0 and flipped:
		flip()
	
	global_rotation = atan2(look_vec.y, look_vec.x)
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	if cur_weapon == null:
		return
	cur_weapon.shoot()

func destroy_cur_weapon():
	cur_weapon.disconnect("done_shooting", self, "destroy_cur_weapon")
	hand.remove_child(cur_weapon)
	get_tree().get_root().add_child(cur_weapon)
	cur_weapon.destroy()
	if hand.get_child_count() > 0:
		cur_weapon = hand.get_child(hand.get_child_count()-1)
		cur_weapon.show()
	else:
		cur_weapon = null
	slots_used -= 1
	emit_weapons_updated()

var weapon_being_picked_up = null
func pickup_weapon(weapon: Weapon):
	if weapon == weapon_being_picked_up:
		return # sometimes calls twice with same item
	if total_slots <= slots_used:
		return
	weapon_being_picked_up = weapon
	weapon.pickup()
	yield(get_tree(), "idle_frame")
	parent_weapon_to_hand(weapon)
	weapon.connect("done_shooting", self, "destroy_cur_weapon")
	if cur_weapon == null or !cur_weapon.is_shooting:
		cur_weapon = weapon
		for child in hand.get_children():
			child.hide()
		cur_weapon.show()
	else:
		weapon.hide()
	weapon_being_picked_up = null
	slots_used += 1
	emit_weapons_updated()

func parent_weapon_to_hand(weapon: Weapon):
	if weapon.get_parent():
		weapon.get_parent().remove_child(weapon)
	hand.add_child(weapon)
	weapon.rotation = 0
	weapon.position = Vector2.ZERO
	weapon.scale = Vector2.ONE

func flip():
	flipped = !flipped
	scale.y *= -1

func kill():
	dead = true

func emit_weapons_updated():
	emit_signal("weapons_updated", hand.get_children())
