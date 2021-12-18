extends Area2D

onready var collision = $CollisionShape2D
onready var sprite = $Sprite
var timer = preload("res://objects/timer.tscn")
var timer_instance
var timer_instance2
var delay = 1.5
var ready = false

func _ready():
	timer_instance = timer.instance()
	add_child(timer_instance)
	timer_instance2 = timer.instance()
	add_child(timer_instance2)

func _physics_process(delta):
	if !timer_instance.start:
		timer_instance.delay = delay
		timer_instance.start()
	
	if timer_instance.can_act:
		ready = true
		sprite.position.x = -1.26
		sprite.scale.x = 5.919
		sprite.self_modulate = Color(1, 1, 1, 1)
		collision.disabled = false
	
	if ready and !timer_instance2.start:
		delay = 3
		timer_instance2.delay = delay
		timer_instance2.start()
	
	if timer_instance2.can_act and ready:
		queue_free()

func start_timer():
	if !timer_instance.start:
		timer_instance.delay = delay
		timer_instance.start()

func _on_laser_body_entered(body):
	if body.is_in_group("player"):
		body.player_hit()
