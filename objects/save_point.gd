extends Node
onready var save = get_tree().current_scene.find_node("save_load")
onready var player = get_tree().current_scene.find_node("player")
var pause = preload("res://objects/pause.tscn")

func _physics_process(delta):
	if Input.is_action_just_pressed("save") and player.saving:
		get_tree().paused = true
		$CanvasLayer/Control.visible = true
	elif !player.saving:
		$CanvasLayer/Control.visible = false

func _on_save_point_body_entered(body):
	if body.is_in_group("player"):
		player.saving = true #true

func _on_Save_pressed():
	save.save_data(get_tree().current_scene.name)
	$CanvasLayer/Control/jogo_salvo.visible = true
	yield(get_tree().create_timer(0.5), "timeout")
	$CanvasLayer/Control.visible = false
	$CanvasLayer/Control/jogo_salvo.visible = false
	player.saving = false
	get_tree().paused = false


func _on_nao_pressed():
	get_tree().paused = false
	$CanvasLayer/Control.visible = false
	$CanvasLayer/Control/jogo_salvo.visible = false
	player.saving = false #false


func _on_save_point_body_exited(body):
	if body.is_in_group("player"):
		player.loading = false #false
		player.saving = false #false

