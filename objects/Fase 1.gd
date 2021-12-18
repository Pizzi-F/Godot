extends Node2D

onready var loadGD = get_tree().current_scene.find_node("save_load")
onready var save = get_tree().current_scene.find_node("save_load")
onready var player = get_tree().current_scene.find_node("player")

func _physics_process(delta):
	if Global.loadGame:
		$load_fade/ColorRect.visible = true
		loadGD.load_data()
		yield(get_tree().create_timer(1.5), "timeout")
		$load_fade/ColorRect.visible = false
		set_physics_process(false)
	else:
		$load_fade/ColorRect.visible = false
		set_physics_process(false)


func _on_fase2_body_entered(body):
	if body.is_in_group("player"):
		player.coin_hunt = false
		save.save_data("Fase 2")
		get_tree().change_scene("res://objects/Fase 2.tscn")
