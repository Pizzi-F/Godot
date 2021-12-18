extends Node

onready var player = get_parent().get_parent().get_parent()
onready var player_gun = player.get_node("gun")

func save_data(fase):
	var save_values=[
		player.max_hitpoint,
		player.hitpoint,
		player.powerup_roll,
		player.powerup_deflect,
		player.powerup_back,
		player.have_potion,
		player.coin_hunt,
		player.spread_shot,
		player.max_potion,
		player.potion,
		player.saving,
		player.loading,
		player_gun.max_ammo,
		player_gun.ammo,
		player.position.x,
		player.position.y,
		fase
	]
	
	var file = File.new()
	file.open("user://saved_data2.dat", File.WRITE)
	file.store_line(to_json(save_values))
	file.close()

func load_fase():
	var file = File.new()
	if not file.file_exists("user://saved_data2.dat"):
		print("No Save to Load!")
		return
	file.open("user://saved_data2.dat", File.READ)
	var content = parse_json(file.get_line())
	return content[16]

func load_data():
	var file = File.new()
	if not file.file_exists("user://saved_data2.dat"):
		print("No Save to Load!")
		return
	file.open("user://saved_data2.dat", File.READ)
	var content = parse_json(file.get_line())
	for i in 16:
		if i == 0:
			player.max_hitpoint = content[i]
		elif i == 1:
			player.hitpoint = content[i]
		elif i == 2:
			player.powerup_roll = content[i]
		elif i == 3:
			player.powerup_deflect = content[i]
		elif i == 4:
			player.powerup_back = content[i]
		elif i == 5:
			player.have_potion = content[i]
		elif i == 6:
			player.coin_hunt = content[i]
		elif i == 7:
			player.spread_shot = content[i]
		elif i == 8:
			player.max_potion = content[i]
		elif i == 9:
			player.potion = content[i]
		elif i == 10:
			player.saving = content[i]
		elif i == 11:
			player.loading = content[i]
		elif i == 12:
			player_gun.max_ammo = content[i] 
		elif i == 13:
			player_gun.ammo = content[i]
		elif i == 14:
			player.position.x = content[i]
		elif i == 15:
			player.position.y = content[i]
	file.close()
	return content
