extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
		
	if Input.is_action_pressed("left"):
		velocity.x=-SPEED
		if $AnimatedSprite.flip_h==false:
			$AnimatedSprite.flip_h=true
	elif Input.is_action_pressed("right" ):
		velocity.x=SPEED
		if $AnimatedSprite.flip_h==true:
			$AnimatedSprite.flip_h=false
	else:
		velocity.x=0
	if Input.is_action_pressed("up") and is_on_floor() :
		velocity.y=-JUMPSPEED
	
	if not is_on_floor():
		velocity.y+=GRAVITY*delta
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
