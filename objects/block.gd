extends StaticBody2D

onready var player = get_tree().current_scene.get_node("player")
onready var boss = get_tree().current_scene.find_node("boss")

func _physics_process(delta):
	if player.global_position.x >= 7500:
		$CollisionShape2D.disabled = false
		$Sprite.visible = true
	if boss.vida <= 0:
		queue_free()
