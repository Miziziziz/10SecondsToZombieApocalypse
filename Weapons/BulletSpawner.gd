extends Position2D


var bullet_obj = preload("res://Weapons/Bullet.tscn")

func fire():
	var bullet_inst = bullet_obj.instance()
	get_tree().get_root().add_child(bullet_inst)
	bullet_inst.global_position = global_position
	bullet_inst.global_rotation = global_rotation
	bullet_inst.init()
