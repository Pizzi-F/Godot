extends Area2D
onready var coisa = get_tree().current_scene.find_node("enemy_int")
var picked = false

func _on_coin_area_entered(area):
	if area.is_in_group("int_en") and !picked:
		picked = true
		$AudioStreamPlayer.play()
		$AnimatedSprite.visible = false
		coisa.moeda += 1

func _on_AudioStreamPlayer_finished():
	queue_free()
