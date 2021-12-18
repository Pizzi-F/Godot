extends Label

onready var boss = get_parent()
onready var life_total = boss.vida_max

func _physics_process(delta):
	if boss.vida > life_total - 1:
		text = "Vida Cheia"
		self_modulate = Color(0, 1, 0)
	elif boss.vida > life_total - (life_total * 25)/100:
		text = "Vida Basicamente Cheia"
		self_modulate = Color(0, 1, 0)
	elif boss.vida >= life_total/2:
		text = "Machucado"
		self_modulate = Color(1, 1, 0)
	elif boss.vida >= life_total - (life_total * 75)/100:
		text = "Muito Machucado"
		self_modulate = Color(0.89, 0.67, 0.07)
	elif boss.vida >= life_total - (life_total * 90)/100:
		text = "Morrendo"
		self_modulate = Color(1, 0, 0)
