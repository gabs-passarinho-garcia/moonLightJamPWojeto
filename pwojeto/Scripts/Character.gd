extends KinematicBody2D


var SPEED=450
var GRAVITY=1200
var JUMPSPEED=600
var velocity=Vector2()
var has_double_jump=true
var life=100
var double_jump_cost=10
var wall_jump_cost=5
var has_wall_jump=true
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
		
	if Input.is_action_pressed("left") and $WallJumpTimer.is_stopped():
		velocity.x=-SPEED
		if $Sprite.flip_h==false:
			$Sprite.flip_h=true
	elif Input.is_action_pressed("right" ) and $WallJumpTimer.is_stopped():
		velocity.x=SPEED
		if $Sprite.flip_h==true:
			$Sprite.flip_h=false
	elif $WallJumpTimer.is_stopped():
		velocity.x=0
	if Input.is_action_just_pressed("jump") :
		if is_on_floor():
		
			velocity.y=-JUMPSPEED
		elif is_on_wall():
			wall_jump()
			
		elif has_double_jump:
			
			double_jump()
		
	if not is_on_floor():
		velocity.y+=GRAVITY*delta
	else:
		has_double_jump=true
		has_wall_jump=true
	velocity=move_and_slide(velocity,Vector2(0,-1))
	
func double_jump():
	velocity.y=-JUMPSPEED
	has_double_jump=false
	damage(double_jump_cost)

func wall_jump():
	if velocity.x!=0 and has_wall_jump:
		velocity.y=-JUMPSPEED
		velocity.x=-velocity.x
		$WallJumpTimer.start()
		damage(wall_jump_cost)
		has_wall_jump=false
		$Sprite.flip_h=(not $Sprite.flip_h)
func damage(damage):
	life-=damage
	if life<0:
		queue_free()
