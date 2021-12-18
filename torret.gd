extends Sprite

var can_fire = true
var bullet = preload("res://objects/enemy_bullet.tscn")
onready var player = get_node("/root/Fase 1/player")
onready var hurtbox = get_parent().get_node("hurtbox")
onready var anim = get_parent().get_node("AnimationPlayer")
onready var torret = get_parent()

var timer = null
var delay = 1
var can_shoot = true
var bullet_instance
var hitpoint = 6

func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	set_physics_process(false)

func on_timeout_complete():
	can_shoot = true

func _physics_process(delta):
	timer.set_wait_time(delay)
	var mouse_pos = player.global_position
	look_at(mouse_pos)
	torret.get_node("CollisionShape2D").set_rotation_degrees(get_rotation_degrees())
	hurtbox.set_rotation_degrees(get_rotation_degrees())
	die()
	gun_direction(mouse_pos)
	
	if can_shoot:
		bullet_instance = bullet.instance()
		bullet_instance.rotation = rotation
		bullet_instance.position = $Position2D.global_position
		get_parent().add_child(bullet_instance)
		can_shoot = false
		rand()
		timer.start()

func die():
	if hitpoint <= 0:
		get_parent().queue_free()

func rand():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	delay = rng.randf_range(1, 2)

func gun_direction(mouse_pos):
	if mouse_pos.x < get_parent().global_position.x:
		flip_v = true

	else:
		flip_v = false


func _on_VisibilityNotifier2D_screen_exited():
	set_physics_process(false)


func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)


func _on_hurtbox_area_entered(area):
	area.queue_free()
	anim.play("flash")
	hitpoint -= 1
