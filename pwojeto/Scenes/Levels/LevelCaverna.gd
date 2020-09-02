extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.cena_atual = "res://Scenes/Levels/LevelCaverna_Ana.tscn"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_exited(body):
	if body.is_in_group("character") and (not Global.voltandoMenu):
		Loading.goto_scene("res://Scenes/menus/Game_over.tscn")
	elif body.is_in_group("enemy") and (not Global.voltandoMenu):
		body.queue_free()
	pass # Replace with function body.
