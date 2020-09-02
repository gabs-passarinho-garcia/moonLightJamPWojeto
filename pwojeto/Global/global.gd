extends Node

var cena_atual
var life = 100
var itens = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func save_game(): #user://savegame.save
	var save_dict = {
		"cena_atual" : cena_atual,
		"life" : life,
		"itens" : itens
		}
	var save_game = File.new() #user://savegame.save
	if not save_game.file_exists("user://savegame.save"):
		save_game.open("user://savegame.save", File.WRITE)
	else:
		save_game.open("user://savegame.save", File.READ_WRITE)
	save_game.store_line(to_json(save_dict))
	save_game.close()
	return

func game_load():
	var content = ""
	var file = File.new()
	if file.file_exists("user://savegame.save"):
		file.open("user://savegame.save", file.READ)
		content = file.get_as_text()
		file.close()
	else:
		return null
	var result = JSON.parse(content)
	var dict = result.result
	if (dict):
		cena_atual = dict.cena_atual
		life = dict.life
		itens = dict.itens
		Loading.goto_scene(cena_atual)
	else:
		print("Error: wrong JSON format, Screwed up loser")
		return null
	pass
