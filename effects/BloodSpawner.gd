extends Node2D

var blood_particle_obj = preload("res://effects/BloodParticle.tscn")

var min_blood_particles = 10
var max_blood_particles = 15
var min_spray_dist = 10
var max_spray_dist = 50
var spray_arc = 60

func spray_blood(dir: Vector2):
	var num_of_particles = (randi() % (max_blood_particles - min_blood_particles)) + min_blood_particles
	for _i in range(num_of_particles):
		var blood_particle_inst = blood_particle_obj.instance()
		get_tree().get_root().add_child(blood_particle_inst)
		var spray_dir = dir.rotated(deg2rad(rand_range(-spray_arc/2.0, spray_arc/2.0))).normalized()
		var end_pos = global_position + spray_dir * rand_range(min_spray_dist, max_spray_dist)
		blood_particle_inst.global_rotation = spray_dir.angle()
		
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(global_position, end_pos, [], 1)
		if result: # hit a wall
			blood_particle_inst.global_position = result.position
		else:
			blood_particle_inst.global_position = end_pos
