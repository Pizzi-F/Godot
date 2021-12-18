extends Area2D

onready var player = get_tree().current_scene.get_node("player")

func _on_atk_up_body_entered(body):
	if body.is_in_group("player"):
		player.spread_shot = true
		queue_free()
