extends Area2D

onready var player = get_tree().current_scene.get_node("player")

func _on_powerup_roll_body_entered(body):
	if body.is_in_group("player"):
		player.powerup_roll = true
		get_node("Label").visible = true
		get_node("CollisionShape2D").disabled = true
		$Sprite.visible = false
		yield(get_tree().create_timer(5), "timeout")
		queue_free()
