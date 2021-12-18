extends Area2D

var timer
var timer2
var delay = 0.8
var delay2 = 1
var can_deflect = true

onready var player = get_parent()

func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	timer2 = Timer.new()
	timer2.set_one_shot(true)
	timer2.set_wait_time(delay2)
	timer2.connect("timeout", self, "on_timeout_complete2")
	add_child(timer2)

func _physics_process(delta):
	if Input.is_action_just_pressed("sword") and player.powerup_deflect and can_deflect:
		get_node("deflecting").visible = true
		get_node("deflect_anim").play("deflect")
		get_node("sword_hit").disabled = false
		can_deflect = false
		timer2.start()
		timer.start()
	if !can_deflect or !player.powerup_deflect:
		$glow.visible = false

func on_timeout_complete():
	get_node("sword_hit").disabled = true

func on_timeout_complete2():
	can_deflect = true
	$glow.visible = true


func _on_deflect_anim_animation_finished(anim_name):
	if anim_name == "deflect":
		get_node("deflecting").visible = false
