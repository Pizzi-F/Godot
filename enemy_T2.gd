extends KinematicBody2D

onready var player = get_tree().current_scene.get_node("player")
onready var sprite = $AnimatedSprite

export var speed = 250
export var gravity = 10

var direction = Vector2.ZERO
var distance = Vector2.ZERO
var stop = false

var rng = RandomNumberGenerator.new()

var vida = 2

func player_rolling():
	if player.rolling == true:
		set_collision_mask_bit(0, false)
		$hit_box.set_collision_mask_bit(0, false)
	else:
		$hit_box.set_collision_mask_bit(0, true)
		set_collision_mask_bit(0, true)
		
func distance_to_player():
	distance.x = player.position.x - position.x
	distance.y = player.position.y - position.y
	if distance.x < 0:
		distance.x *= -1
	if distance.y < 0:
		distance.y *= -1
	return distance

func sprite_direction():
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	die()
	player_rolling()
	direction = (player.position - position).normalized()
	sprite_direction()
	if distance_to_player().x > 15 and !stop:
		move_and_slide(direction * speed, Vector2.UP)

func die():
	if vida <= 0:
		queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		stop = true

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		stop = false

func _on_hurt_box_body_entered(body):
	if body.is_in_group("player") and !player.rolling:
		player.player_hit()

func _on_hit_box_area_entered(area):
	var number
	var number2
	if area.is_in_group("player_bullet"):
		rng.randomize()
		if player.spread_shot:
			number = rng.randi_range(1, 6)
		else:
			number = rng.randi_range(1, 4)
		if number == 1:
			vida -= 1
			$AnimationPlayer.play("flash")
		else:
			$Label.visible = true
			number = 20
			number2 = rng.randi_range(5, 10)
			if(direction.x < 0):
				position = position + Vector2(number, number2)
			if(direction.x > 0):
				position = position - Vector2(number, number2)
			yield(get_tree().create_timer(1), "timeout")
			$Label.visible = false

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)
