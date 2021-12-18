extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer = preload("res://objects/timer.tscn")

var currentPath
var currentTarget
var pathFinder
var player

var speed = 350
var jumpForce = 450
var gravity = 700
var padding = 2
var finishPadding = 10

var moeda = 0

var timer_start
var movement
var timer_instance
# Called when the node enters the scene tree for the first time.
func _ready():
	pathFinder = get_tree().current_scene.find_node("pathfinder")
	player = get_tree().current_scene.find_node("player")
	movement = Vector2(0, 0)
	timer_instance = timer.instance()
	add_child(timer_instance)
	moeda = 0
	pass # Replace with function body.


func nextPoint():
	if len(currentPath) == 0:
		currentTarget = null
		return
	
	currentTarget = currentPath.pop_front()
	
	if !currentTarget:
		jump()
		nextPoint()

func jump():
	if (self.is_on_floor()):
		movement[1] = -jumpForce
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

func anim():
	if movement.x < 0:
		$AnimatedSprite.play("run") 
		$AnimatedSprite.flip_h = true
	if movement.x > 0:
		$AnimatedSprite.play("run") 
		$AnimatedSprite.flip_h = false
	if movement.x == 0:
		$AnimatedSprite.play("idle") 

func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	if timer_instance.can_act:
		timer_start = false
		timer_instance.can_act = false
	if !timer_start:
		timer_start = true
		timer_instance.delay = 2
		timer_instance.start()
		var mousePos = player.get_global_position()
		#var mousePos = get_global_mouse_position()
		var result = space_state.intersect_ray(mousePos, Vector2(mousePos[0], mousePos[1] + 1000))
		if (result):
			var goTo = result["position"]
			currentPath = pathFinder.findPath(self.position, goTo)
			nextPoint()
	
	if currentTarget:
		#print(currentTarget, position[0])
		if (currentTarget[0] - padding > position[0]): # and position.distance_to(currentTarget) > padding:
			movement[0] = speed
		elif (currentTarget[0] + padding < position[0]): # and position.distance_to(currentTarget) > padding:
			movement[0] = -speed
		else:
			movement[0] = 0
			
		if position.distance_to(currentTarget) < finishPadding and is_on_floor():
				nextPoint()
	else:
		movement[0] = 0
	
	if !is_on_floor():
		movement[1] += gravity * delta
#	elif movement[1] > 0:
#		movement[1] = 0
	self.move_and_slide(movement, Vector2(0, -1))
	anim()
