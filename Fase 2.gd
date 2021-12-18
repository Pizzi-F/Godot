extends Node2D

onready var loadGD = get_tree().current_scene.find_node("save_load")
onready var save = get_tree().current_scene.find_node("save_load")
onready var player = get_tree().current_scene.find_node("player")
onready var hud = $HUD

var player_pos

func _physics_process(delta):
	if !Global.fase2:
		player_pos = player.position
		loadGD.load_data()
		player.position = player_pos
		save.save_data("Fase 2")
		Global.fase2 = true
	if Global.loadGame and Global.fase2:
		$load_fade/ColorRect.visible = true
		loadGD.load_data()
		yield(get_tree().create_timer(1.5), "timeout")
		$load_fade/ColorRect.visible = false
		set_physics_process(false)
	else:
		$load_fade/ColorRect.visible = false
		set_physics_process(false)
