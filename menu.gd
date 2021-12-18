extends CanvasLayer

onready var loadGD = $load/save_load
var fase

func _on_Jogar_pressed():
	get_tree().change_scene("res://objects/Fase 1.tscn")

func _on_Sair_pressed():
	get_tree().quit()

func _on_load_pressed():
	fase = loadGD.load_fase()
	Global.loadGame = true
	if fase == "Fase 1":
		get_tree().change_scene("res://objects/Fase 1.tscn")
	elif fase == "Fase 2":
		get_tree().change_scene("res://objects/Fase 2.tscn")
