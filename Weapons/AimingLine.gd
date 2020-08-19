extends RayCast2D

export (Color) var line_color
var is_drawing = false

func set_drawing(do_draw: bool):
	is_drawing = do_draw

func _process(_delta):
	update()

func _draw():
	if is_drawing:
		var end_p = cast_to
		if is_colliding():
			end_p = to_local(get_collision_point())
		draw_line(Vector2.ZERO, end_p, line_color, 1.5)
