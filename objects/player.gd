extends KinematicBody2D

var timer = preload("res://objects/timer.tscn")

var move = Vector2.ZERO
var speed = 250
var jump_speed = 500
var grv = 10
var rolling = false
var enemies_following = -2
var timer_instance
var max_hitpoint = 100
var hitpoint = 100
var is_moving

onready var animation = $AnimatedSprite
onready var screen_shaker = $Camera2D/screen_shaker
onready var sword = $sword/sword_hit
onready var hit_effect = $player_hit
onready var ghost = get_tree().current_scene.find_node("enemy_int")
onready var morreuRect = $morreu/ColorRect
onready var morreuAnim = $morreu/ColorRect/morreu
onready var morreuLabel = $morreu/ColorRect/Label

#POWER-UPS---------------------------------------

var powerup_roll = false
var powerup_deflect = false
var powerup_back = false
var have_potion = false
var coin_hunt = false
var spread_shot = false

#------------------------------------------------

var max_potion = 1
var potion = 0

var player_fase

var saving = false
var loading = false

var jump_pos = Vector2.ZERO

func _ready():
	timer_instance = timer.instance()
	timer_instance.can_act = true
	add_child(timer_instance)

func _physics_process(delta):
	morre()
	movement()
	use_pot()
	move = move_and_slide(move, Vector2.UP)
	if move.x == 0:
		is_moving = false
	else:
		is_moving = true
	animation_select()

func movement():
	move.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * speed
	move.y += grv
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		move.y -= jump_speed
		jump_pos.x = position.x
	if Input.is_action_just_pressed("ui_accept") and powerup_roll and timer_instance.can_act == true and move.x != 0:
		$AnimationPlayer.seek(0, true)
		move.x *= 10
		if move.x > 0:
			timer_instance.can_act = false
			timer_instance.delay = 0.5
			timer_instance.start()
			$AnimationPlayer.play("roll")
			rolling = true
		elif move.x < 0:
			timer_instance.can_act = false
			timer_instance.delay = 0.5
			timer_instance.start()
			$AnimationPlayer.play("roll 2")
			rolling = true

func morre():
	if hitpoint <= 0:
		var file = File.new()
		if not file.file_exists("user://saved_data2.dat"):
			Global.loadGame = false
			get_tree().reload_current_scene()
		else:
			Global.loadGame = true
			morreuRect.visible = true
			morreuAnim.play("fade")
			yield(get_tree().create_timer(0.5), "timeout")
			morreuLabel.visible = true
			yield(get_tree().create_timer(2), "timeout")
			morreuRect.visible = false
			morreuLabel.visible = false
			get_tree().reload_current_scene()

func use_pot():
	if Input.is_action_just_pressed("pocao") and hitpoint < max_hitpoint and potion > 0:
		potion -= 1
		hitpoint = max_hitpoint

func animation_select():
	if move.x == 0:
		animation.play("idle")
	
	if move.y < 0:
		animation.play("jump")

	if move.y > 0 and !is_on_floor():
		animation.play("falling")
	
	if move.x != 0 and is_on_floor():
		animation.play("run")

func player_hit():
	$AnimationPlayer.play("hit")
	hit_effect.play()
	hitpoint -= 1

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "roll" or anim_name == "roll 2":
		animation.frame = 0
		rolling = false

func _on_morreu_animation_finished(anim_name):
	$morreu/ColorRect.color = Color(1, 1, 1, 1)
