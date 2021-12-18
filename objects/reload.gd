extends Label

onready var gun = get_parent().get_node("gun")

func _physics_process(delta):
	if gun.timer_start:
		visible = true
		text = "RELOADING! " + str(gun.time_left)
		if gun.time_left as float <= 1.0:
			self_modulate = Color(0, 1, 0, 1)
	else:
		visible = false
		self_modulate = Color(1, 1, 1, 1)
