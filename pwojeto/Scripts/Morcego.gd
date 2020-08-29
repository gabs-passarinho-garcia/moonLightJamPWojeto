extends KinematicBody2D
var alvo=null
var velocity=Vector2(0,0)
var SPEED=200
var DAMAGE=25
var knockback_speed=1000
var following=false
func _physics_process(delta):
	if alvo!=null and following and $KnockbackTimer.is_stopped():
		velocity=alvo.global_position-global_position
		velocity=velocity.normalized()*SPEED
	elif $KnockbackTimer.is_stopped():
		velocity=Vector2(0,0)
	velocity=move_and_slide(velocity)
	for i in get_slide_count():
			var collision=get_slide_collision(i)
			if collision and collision.collider.is_in_group("character"):
				collision.collider.damage(DAMAGE)
				knockback()
	if velocity.x<0 and $AnimatedSprite.flip_h==true:
		$AnimatedSprite.flip_h=false
	elif velocity.x>0 and $AnimatedSprite.flip_h==false:
		$AnimatedSprite.flip_h=true
	if alvo!=null and not following:
		follow_checker()

func _on_Area2D_body_entered(body):
	if body.is_in_group("character"):
		$RayCast2D.set_cast_to(body.global_position-global_position)
		$RayCast2D.force_raycast_update()
		if $RayCast2D.get_collider()==body:
			alvo=body

func _on_Range_body_exited(body):
	if body.is_in_group("character"):
		alvo=null
func follow_checker():
	$RayCast2D.set_cast_to(alvo.global_position-global_position)
	$RayCast2D.force_raycast_update()
	if $RayCast2D.get_collider()==alvo:
		following=true
		$AnimationPlayer.play("walking")
func hit():
	queue_free()
	
func knockback():
	velocity*=-1
	velocity=velocity.normalized()*knockback_speed
	$KnockbackTimer.start()
