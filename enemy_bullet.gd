extends Area2D

export var speed = 800
var deflected = false
onready var player_ref = get_node("/root/Fase 1/player/gun")

func _ready():
	set_as_toplevel(true)

func _process(delta):
	deflect(delta)

func _physics_process(delta):
	yield(get_tree().create_timer(0.01), "timeout")
	$Sprite.frame = 1
	set_physics_process(false)

func deflect(delta):
	if deflected == true:
		position -= (Vector2.RIGHT * speed).rotated(rotation) * delta
	else:
		position += (Vector2.RIGHT * speed).rotated(rotation) * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_enemy_bullet_body_entered(body):
	if body.name == "player" and body.rolling == true:
		return
	#se defletido e o tiro acertar o inimigo que disparou
	if deflected == true and body.is_a_parent_of(self):
		queue_free()
	if body.get_parent().name != "enemies":
		if body.name == "player" and body.rolling == false:
			body.player_hit()
		queue_free()

func _on_enemy_bullet_area_entered(area):
	if area.name == "sword":
		$Sprite.flip_h = true
		deflected = true
		speed = 1200
		set_collision_mask(4)
		if player_ref.max_ammo > player_ref.ammo:
			player_ref.ammo += 3
