extends Node2D


var lixo = 0
onready var play_button = $newGame
onready var load_button = $continueGame
onready var quit_button = $quit

func _ready():
	play_button.connect("button_down",self,"on_play_down")
	load_button.connect("button_down",self,"on_load_down")
	quit_button.connect("button_down",self,"on_quit_down")
	

func on_play_down():
	lixo = get_tree().change_scene("res://Scenes/Levels/LevelCaverna.tscn")
	pass

func on_quit_down():
	get_tree().quit()
	pass
func on_load_down():
	Global.game_load()
	pass
