extends KinematicBody2D
var alvo=null
var velocity=Vector2(0,0)
var CLIMBSPEED=200
var SPEED=200
var GRAVITY=100
var is_jumping=false
var JUMP_ANGLE=PI/6
var JUMP_SPEED=1000
var KNOCKBACK_ANGLE=PI/4
var KNOCKBACK_SPEED=1000
var DAMAGE=30
func _ready():
	
	add_to_group("enemie")
	pass


func _physics_process(delta):
	if alvo!=null:
		if not is_jumping:

			if(global_position<alvo.global_position):
				velocity.x=SPEED
				$Sprite.flip_h = false
				$AnimationPlayer.play("andando")
			elif global_position>alvo.global_position:
				$Sprite.flip_h = true
				$AnimationPlayer.play("andando")
				velocity.x=-SPEED
			else:
				velocity.x=0
				$AnimationPlayer.play("parado")
			if is_on_wall():

				velocity.y=-CLIMBSPEED
			elif not is_on_floor():
				velocity.y+=GRAVITY
			if is_on_floor() and ((velocity.x<0 and  not $RayCastLeft.is_colliding() )or(velocity.x>0 and not $RayCastRight.is_colliding())):
				jump()
		elif (is_on_floor() or is_on_wall())and $JumpTimer.is_stopped() and $KnockbackTimer.is_stopped():
			is_jumping=false
		else:
			velocity.y+=GRAVITY
		velocity=move_and_slide(velocity,Vector2(0,-1))
		for i in get_slide_count():
			var collision=get_slide_collision(i)
			if collision and collision.collider.is_in_group("character"):
				collision.collider.damage(DAMAGE)
				knockback()



func _on_Area2D_body_entered(body):
	if body.is_in_group("character"):
		$RayCast2D.set_cast_to(body.global_position-global_position)
		$RayCast2D.force_raycast_update()
		if $RayCast2D.get_collider()==body:
			alvo=body


func _on_Area2D_body_exited(body):
	if body.is_in_group("character"):
		alvo=null
func jump():
	
	$JumpTimer.start()
	is_jumping=true
	if velocity.x>0:
		velocity=Vector2(0,-1).rotated(JUMP_ANGLE)*JUMP_SPEED
	else:
		velocity=Vector2(0,-1).rotated(-JUMP_ANGLE)*JUMP_SPEED
func knockback():
	$KnockbackTimer.start()
	is_jumping=true
	if velocity.x>0:
		velocity=Vector2(0,-1).rotated(KNOCKBACK_ANGLE)*KNOCKBACK_SPEED
	else:
		velocity=Vector2(0,-1).rotated(-KNOCKBACK_ANGLE)*KNOCKBACK_SPEED


func _on_KnockbackTimer_timeout():
	is_jumping=false
	
func hit():
	queue_free()
