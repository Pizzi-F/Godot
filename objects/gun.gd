extends Sprite

var can_fire = true
var bullet = preload("res://objects/bullet.tscn")
var timer = preload("res://objects/timer.tscn")
var shot = preload("res://objects/gun_shot.tscn")
onready var player = get_parent()

var timer_instance
var timer_start = false
var time_left

var reload_time = 1.5
var max_ammo = 15
var ammo = 15

func _ready():
	timer_instance = timer.instance()
	add_child(timer_instance)

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	reload()
	fast_reload()
	gun_direction(mouse_pos)
	
	if Input.is_action_just_pressed("fire") and ammo != 0 and player.rolling == false:
		var n
		ammo -= 1
		if player.spread_shot:
			n = 3
		else:
			 n = 1
		var bullet_instance
		var gun_shot = shot.instance()
		get_parent().add_child(gun_shot)
		gun_shot.play()
		for i in n:
			bullet_instance = bullet.instance()
			if i == 0:
				bullet_instance.rotation = rotation
			elif i == 1:
				bullet_instance.rotation = rotation + 0.05
			elif i == 2:
				bullet_instance.rotation = rotation - 0.05
			bullet_instance.position = $Position2D.global_position
			get_parent().add_child(bullet_instance)
		#bullet_instance.position = $Position2D.global_position
		get_parent().screen_shaker._shake(0.2, 6)
		#get_parent().add_child(bullet_instance)
		

func fast_reload():
	if timer_start:
		time_left = timer_instance.time_left()
		if time_left as float <= 1.0 and Input.is_action_just_pressed("reload"):
			ammo = max_ammo
			timer_instance.can_act = false
			timer_start = false
			timer_instance.stop_timer()

func reload():
	if ammo == 0 and timer_start == false:
		timer_instance.delay = reload_time
		timer_instance.start()
		time_left = timer_instance.time_left()
		timer_start = true
	if timer_instance.can_act == true:
		ammo = max_ammo
		timer_instance.can_act = false
		timer_start = false

func gun_direction(mouse_pos):
	if mouse_pos.x < get_parent().global_position.x:
		flip_v = true
		get_parent().animation.flip_h = true
		get_parent().get_node("sword").set_rotation_degrees(180)
		offset.x = 10
	else:
		flip_v = false
		get_parent().animation.flip_h = false
		get_parent().get_node("sword").set_rotation_degrees(0)
		offset.x = 0
