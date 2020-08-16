extends KinematicBody2D

var damage = 1
var speed = 500
var move_vec : Vector2

func _ready():
	$HitArea.connect("body_entered", self, "hit_body") #used in case body hits side or back of bullet somehow
	init()

func init():
	move_vec = Vector2.RIGHT
	move_vec = move_vec.rotated(global_rotation)

func hit_body(body: PhysicsBody2D):
	if is_instance_valid(body) and body.has_method("hurt"):
		deal_damage(body)

func _physics_process(delta):
	var coll = move_and_collide(move_vec * speed * delta)
	if coll:
		if coll.collider.has_method("hurt"):
			deal_damage(coll.collider)
		else:
			destroy_bullet()

func deal_damage(body):
	body.hurt(damage, move_vec)
	destroy_bullet()

func destroy_bullet():
	speed = 0
	$CollisionShape2D.call_deferred("set_disabled", true)
	$HitArea/CollisionShape2D2.call_deferred("set_disabled", true)
	$Sprite.hide()
	$HitCPUParticles2D.emitting=true
	#queue_free()
