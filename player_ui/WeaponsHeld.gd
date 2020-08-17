extends GridContainer

var slots_unlocked = 1

func init():
	var ind = 0
	for slot in get_children():
		if ind >= slots_unlocked:
			slot.hide()
		slot.get_node("SlotContents").texture = null
		ind += 1

func update_weapons_held(equipped_weapons_list: Array):
	for i in range(slots_unlocked):
		var slot_contents = get_child(i).get_node("SlotContents")
		if i < equipped_weapons_list.size():
			var txt = equipped_weapons_list[i].get_node("Graphics/Sprite").texture
			slot_contents.texture = txt
		else:
			slot_contents.texture = null
	
