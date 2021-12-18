extends CanvasLayer

onready var player_gun = get_tree().current_scene.get_node("player").get_node("gun")
onready var player = get_tree().current_scene.get_node("player")
onready var ammo = get_node("ammo")
onready var hp = get_node("HP")
onready var pocoes = get_node("pocoes")
onready var sprite = get_node("Sprite")
onready var atk_up = get_node("atkup")
onready var moeda = $moedas
onready var tempo = $tempo
onready var coisa = get_tree().current_scene.find_node("enemy_int")
onready var pot = get_tree().current_scene.find_node("change_player_camera")
onready var coin_hunt = $coin_hunt
onready var distance = $distance

var timer = preload("res://objects/timer.tscn")
var timer_instance

var time_start
var elapsed_time
var distancia_c = Vector2.ZERO

var one_time = false

func _ready():
	timer_instance = timer.instance()
	add_child(timer_instance)

func _physics_process(delta):
	coin()
	distancia_coisa()
	print_dist()
	if player_gun.ammo <= 5:
		ammo.self_modulate = Color(1, 0, 0, 1)
	else:
		ammo.self_modulate = Color(1, 1, 1, 1)
	ammo.text = "Ammo: "+str(player_gun.ammo)
	hp.text = "HP: "+str(player.hitpoint)
	if player.have_potion and !player.coin_hunt:
		sprite.visible = true
		pocoes.visible = true
		pocoes.text = str(player.potion) + "/" + str(player.max_potion)
	
	if player.spread_shot and !player.coin_hunt:
		atk_up.visible = true
	else:
		atk_up.visible = false

func distancia_coisa():
	distancia_c = player.position - coisa.position
	if distancia_c.x < 0:
		distancia_c.x *= -1

func print_dist():
	if distancia_c.x < 300:
		distance.self_modulate = Color(1, 1, 1)
	elif distancia_c.x < 800:
		distance.self_modulate = Color(0, 1, 0)
	else:
		distance.self_modulate = Color(1, 0, 0)
func coin():
	if player.coin_hunt:
		if !one_time:
			time_start = OS.get_ticks_msec()
			one_time = true
		elapsed_time = OS.get_ticks_msec() - time_start
		elapsed_time /= 1000.0
		ammo.visible = false
		hp.visible = false
		pocoes.visible = false
		sprite.visible = false
		atk_up.visible = false
		moeda.visible = true
		tempo.visible = true
		coin_hunt.visible = true
		distance.visible = true
		$AnimationPlayer.play("coin_hunt")
	moeda.text = "Moedas: " + str(coisa.moeda) + "/115"
	tempo.text = "Tempo: " + str(elapsed_time).pad_decimals(2)
	distance.text = "Distância da Coisa: " + str(distancia_c.x).pad_decimals(2)
	
