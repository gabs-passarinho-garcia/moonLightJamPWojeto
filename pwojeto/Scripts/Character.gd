extends KinematicBody2D


var SPEED=450
var GRAVITY=1200
var JUMPSPEED=600
var velocity=Vector2()
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
		
	if Input.is_action_pressed("left"):
		velocity.x=-SPEED
		if $Sprite.flip_h==false:
			$Sprite.flip_h=true
	elif Input.is_action_pressed("right" ):
		velocity.x=SPEED
		if $Sprite.flip_h==true:
			$Sprite.flip_h=false
	else:
		velocity.x=0
	if Input.is_action_pressed("jump") and is_on_floor() :
		print(1)
		velocity.y=-JUMPSPEED
	
	if not is_on_floor():
		velocity.y+=GRAVITY*delta
	velocity=move_and_slide(velocity,Vector2(0,-1))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
