extends Control

onready var label = $ColorRect
onready var player = get_tree().current_scene.get_node("player")
onready var save = $save_load
onready var loadGD = $save_load
onready var save_complete = $ColorRect/save_complete
onready var fade_to_black = $fade/fade_to_black
onready var loadAnim = get_node("time_back")

func _input(event):
	if event.is_action_pressed("pause") and !player.saving:
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			label.visible = true
		else:
			label.visible = false

func _on_load_pressed():
	label.visible = false
	loadAnim.frame = 0
	loadAnim.visible = true
	loadAnim.playing = true
	

func _on_fade_to_black_animation_finished(anim_name):
	Global.loadGame = true
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
			label.visible = true
	else:
			label.visible = false
	yield(get_tree().create_timer(1.5), "timeout")
	fade_to_black.get_parent().color = Color(1, 1, 1, 0)
	get_tree().reload_current_scene()


func _on_time_back_animation_finished():
	loadAnim.visible = false
	loadAnim.playing = false
	
	fade_to_black.play("fade")
	player.loading = true #true
