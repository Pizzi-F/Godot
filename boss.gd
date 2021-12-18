extends KinematicBody2D

var timer = preload("res://objects/timer.tscn")
var laser = preload("res://objects/laser.tscn")

onready var player = get_tree().current_scene.get_node("player")
onready var anim = $AnimationPlayer
onready var sprite = $Sprite
onready var hurt_box = get_node("hurtbox/CollisionShape2D2")

var direction = Vector2.ZERO
var speed = 600
var stop = false
var bugstop = false
var atk_type = 2

var max_right = 8100
var max_left = 7100

var bean_distance = 150

var atk_selected = false
#esta atacando no momento
var is_atk = false
#tempo entre cada ataque 1
var atk_delay
#quantas vezes usou ataque 1
var atk_count = 0

var anim_finish = true

var timer_instance
var timer2

var rng = RandomNumberGenerator.new()

var laser_instance
var n = 0
var pos = Vector2.ZERO

var vida = 50
var vida_max = 300

func _ready():
	timer_instance = timer.instance()
	add_child(timer_instance)
	timer2 = timer.instance()
	add_child(timer2)
	set_physics_process(false)
	pos.x = 7550
	pos.y = 150
	vida = vida_max

func _process(delta):
	gogo()

func _physics_process(delta):
	if atk_count >= 3:
		atk_selected = false
	
	morre()
	atk_select()
	attacks()
	time_out()
	time_out2()
	pass

func move_to_player():
	if player:
		direction = (player.position - position).normalized()
		var pos_distX = position.x - player.position.x
		var pos_distY = position.y - player.position.y
		if pos_distX < 0:
			pos_distX *= -1
		if pos_distY < 0:
			pos_distY *= -1
		
		if pos_distX <= 40 and pos_distY <= 30:
			bugstop = true
		
#		if (position.x - player.position.x < 40 and position.x - player.position.x > 0) or (position.x - player.position.x > -40 and position.x - player.position.x < 0):
#			sprite.self_modulate = Color(1, 1, 1, 1)
#			bugstop = true
#			print(position.x - player.position.x)
#			$Sprite.self_modulate = Color(1, 1, 1, 1)
#			if !timer_instance.start:
#				timer_instance.delay = atk_delay
#				timer_instance.start()
#		if position.x - player.position.x > -42 and position.x - player.position.x < 0:
#			direction.x -= 40
		if bugstop and pos_distX >= 80:
			bugstop = false
		if !stop and !bugstop:
			direction = move_and_slide(direction * 500, Vector2.UP)

func time_out():
	if timer_instance.can_act:
		timer_instance.can_act = false
		timer_instance.start = false
		if atk_type == 1:
			stop = false

func time_out2():
	if timer2.can_act:
		timer2.can_act = false
		stop = false
		atk_selected = false

func atk_select():
	if !atk_selected:
		sprite.self_modulate = Color(1, 1, 1, 1)
		atk_count = 0
		rng.randomize()
		atk_type = rng.randi_range(1, 2)
		if atk_type == 1:
			sprite.self_modulate = Color(1, 0, 0, 1)
		atk_selected = true

func attacks():
	if atk_type == 1:
		atk_delay = 1
		if stop:
			anim_finish = false
			anim.play("blink")
		if anim_finish:
			move_to_player()
	
	if atk_type == 2:
		direction = (pos - position).normalized()
		if (position.x - pos.x < 3 and position.x - pos.x > 0) or (position.x - pos.x > -3 and position.x - pos.x < 0) and (position.y - pos.y < 3 and position.y - pos.y > 0) or (position.y - pos.y > -3 and position.y - pos.y < 0):
			position = pos
		if position.x as int != pos.x as int and position.y as int != pos.y as int:
			move_and_slide(direction * speed)
		if atk_count < 1 and position == pos:
			atk_count += 1
			var player_pos = player.global_position
			laser_instance = laser.instance()
			laser_instance.position = player_pos
			get_parent().add_child(laser_instance)
			for i in 3:
				if i == 0 and player_pos.x - bean_distance >= max_left:
					laser_instance = laser.instance()
					player_pos.x -= bean_distance
					laser_instance.position = player_pos
					get_parent().add_child(laser_instance)
					player_pos.x += bean_distance
				if i != 0 and player_pos.x + bean_distance <= max_right:
					laser_instance = laser.instance()
					player_pos.x += bean_distance
					laser_instance.position = player_pos
					get_parent().add_child(laser_instance)
			timer2.delay = 5
			timer2.start()

func gogo():
	if player.global_position.x >= 7550:
		set_physics_process(true)
		hurt_box.disabled = false
	elif player.global_position.x < 6500:
		set_physics_process(false)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "blink":
		anim_finish = true

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		if !player.rolling:
			player.player_hit()
		stop = true
		atk_count += 1
		if !timer_instance.start:
			timer_instance.delay = atk_delay
			timer_instance.start()

func morre():
	if vida <= 0:
		queue_free()

func _on_hurtbox_area_entered(area):
	if area.is_in_group("player_bullet"):
		vida-=1
