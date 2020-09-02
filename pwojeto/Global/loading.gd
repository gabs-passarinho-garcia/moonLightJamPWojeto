extends Node2D

var loader
var wait_frames
var time_max = 10 # msec
var current_scene
var root
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	pass # Replace with function body.


func goto_scene(path):
	current_scene = root.get_child(root.get_child_count() -1)
	

	call_deferred("_deferred_goto_scene", path)
	
	
func _deferred_goto_scene(path):
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # Check for errors.
		#show_error()
		return
	current_scene.queue_free() # Get rid of the old scene.

	# Start your "loading..." animation.
	$CanvasLayer/Popup/animacao.play("carregando")
	wait_frames = 1
	set_process(true)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return
	print("peixe")
	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			pass
		else: # Error during loading.
			#show_error()
			loader = null
			break



func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
	$CanvasLayer/Popup.visible = false
	$CanvasLayer/Popup/animacao.stop()
