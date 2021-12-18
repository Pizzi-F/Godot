extends Area2D

onready var player = get_tree().current_scene.get_node("player").get_node("gun")
var taken = false

func _on_powerup_max_ammo_body_entered(body):
	if body.is_in_group("player") and !taken:
		taken = true
		player.max_ammo += 5
		player.ammo = player.max_ammo
		get_node("Label").visible = true
		get_node("CollisionShape2D").disabled = true
		$Sprite.visible = false
		yield(get_tree().create_timer(5), "timeout")
		queue_free()

