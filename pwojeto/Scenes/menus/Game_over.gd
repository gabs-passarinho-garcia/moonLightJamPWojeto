extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var continuar = $Retornar_fase
onready var voltar = $Menu_principal

# Called when the node enters the scene tree for the first time.
func _ready():
	continuar.connect("button_down",self,"seguir")
	voltar.connect("button_down",self,"volta_menu")
	pass # Replace with function body.

func seguir():
	Loading.goto_scene(Global.cena_atual)
	pass
func volta_menu():
	Loading.goto_scene("res://Scenes/menus/main_menu.tscn")
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
