extends Area2D

onready var player = get_tree().current_scene.get_node("player")
var time_start = 0

func _on_camera_body_entered(body):
	if body.is_in_group("player"):
		player.get_node("Camera2D").limit_bottom = 3400
		time_start = OS.get_ticks_msec()
		position = Vector2(0, 0)
		visible = false
		player.coin_hunt = true
		queue_free()
