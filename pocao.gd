extends Area2D

onready var player = get_tree().current_scene.get_node("player")
onready var label = $Label
onready var sprite = $Sprite
onready var collision = $CollisionShape2D

var taken = false

func _on_pocao_body_entered(body):
	if body.is_in_group("player"):
		if player.have_potion and player.potion < player.max_potion:
			queue_free()
		if player.potion < player.max_potion and !taken:
			player.potion += 1
			taken = true
			label.visible = true
			sprite.visible = false
			collision.disabled = true
			player.have_potion = true
			yield(get_tree().create_timer(5), "timeout")
			queue_free()
