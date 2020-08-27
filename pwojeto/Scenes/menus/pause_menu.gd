extends Popup


onready var continue_button = $Continue
onready var save_button = $Salvar
onready var back_button = $VoltarMenu
onready var quit_button = $Sair


# Called when the node enters the scene tree for the first time.
func _ready():
	continue_button.connect("button_down",self,"on_continue_down")
	save_button.connect("button_down",self,"on_save_down")
	back_button.connect("button_down",self,"on_back_down")
	quit_button.connect("button_down",self,"on_quit_down")
	pass # Replace with function body.

func on_continue_down():
	self.hide()
	#$AudioStreamPlayer2D.stop()
	get_tree().paused = false
	pass

func on_save_down():
	#Global.save_game()
	pass
func on_back_down():
	get_tree().change_scene("res://Scenes/menus/main_menu.tscn")
	get_tree().paused = false
	pass
	
func on_quit_down():
	get_tree().quit()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
