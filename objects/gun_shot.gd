extends AudioStreamPlayer

func _on_gun_shot_finished():
	queue_free()
