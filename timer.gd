extends Node2D

var timer = null
var delay = 0
var can_act = false
var start = false

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "on_timeout_complete")

func start():
	timer.set_one_shot(true)
	timer.set_wait_time(delay)
	timer.start()
	start = true

func time_left():
	if start:
		return "%.2f" % timer.get_time_left()


func stop_timer():
	if start:
		timer.stop()

func on_timeout_complete():
	can_act = true
	start = false
