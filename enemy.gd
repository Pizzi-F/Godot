extends KinematicBody2D

onready var tilemap = get_tree().current_scene.get_node("TileMap")
onready var player = get_tree().current_scene.get_node("player")
onready var hitbox = $hitbox
onready var anim = $AnimationPlayer

var ini_position

var timer = preload("res://objects/timer.tscn")

export var speed = 300
export var flip = false
export var attack = true
var move = Vector2(speed, 0)
export var hitpoint = 3

var hit_cd = 1.5

var timer_instance

func _ready():
	timer_instance = timer.instance()
	add_child(timer_instance)
	set_physics_process(false)
	ini_position = position

func _process(delta):
	longe()

func _physics_process(delta):
	attack_player()
	die()
	player_rolling()
	hitbox_enable()
	if not is_on_floor():
		move.y += 10
	if attack:
		check_wall()
		move_and_slide(move, Vector2.UP)

func attack_player():
	if player.enemies_following < 2 and !attack:
		player.enemies_following += 1
		attack = true

func player_rolling():
	if player.rolling == true:
		set_collision_mask_bit(0, false)
		$hitbox.set_collision_mask_bit(0, false)
	else:
		$hitbox.set_collision_mask_bit(0, true)
		set_collision_mask_bit(0, true)

func die():
	if hitpoint <= 0:
		if attack:
			player.enemies_following -= 1
		queue_free()

func dir_changed():
	flip = !flip
	$sprite.flip_h = flip
	$obj_detected.rotation_degrees = 180 if flip else 0
	hitbox.rotation_degrees = 180 if flip else 0
	move.x *= -1

func check_wall():
	var tile
	if !flip:
		tile = tilemap.world_to_map(global_position + Vector2(16, 32))
	else:
		tile = tilemap.world_to_map(global_position + Vector2(-16, 32))
	
	var tile_info = tilemap.get_cellv(tile)
	if tile_info == -1:
		dir_changed()

func hitbox_enable():
	if timer_instance.can_act:
		timer_instance.can_act = false
		hitbox.get_node("CollisionShape2D").disabled = false
		hitbox.get_node("CollisionShape2D").position.x = 16.5

func _on_obj_detected_body_entered(body):
	if body.get_parent().name != "enemies" and body.name != "player":
		dir_changed()


func _on_hurtbox_area_entered(area):
	if area.is_in_group("player_bullet"):
		hitpoint -= 1;
		anim.play("flash")


func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		hitbox.get_node("CollisionShape2D").disabled = true
		hitbox.get_node("CollisionShape2D").position.x = 0
		timer_instance.delay = hit_cd
		timer_instance.start()
		body.player_hit()


func _on_VisibilityNotifier2D_screen_entered():
	pass


func longe():
	var dist = player.global_position.x - position.x
	if dist < 0:
		dist *= -1
	if dist >= 4000:
		set_physics_process(false)
		position = ini_position
	else:
		set_physics_process(true)

func _on_VisibilityNotifier2D_screen_exited():
	pass

