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
var ATTACK_DAMAGE=50
var following=false
var not_jumped=true
func _ready():
	add_to_group("enemy")
	pass


func _physics_process(delta):
	if alvo!=null and following:
		if not is_jumping:

			if(global_position<alvo.global_position):
				velocity.x=SPEED
				if $Sprite.flip_h==false:
					$Sprite.flip_h=true
					$Sprite.position.x=-9.4
					$Sprite2.flip_h=true
					$Sprite2.position.x=26.9
			elif global_position>alvo.global_position:
				velocity.x=-SPEED
				if $Sprite.flip_h==true:
					$Sprite.flip_h=false
					$Sprite2.position.x=7.95
					$Sprite2.flip_h=false
					$Sprite2.position.x=-26.4
			else:
				velocity.x=0
			
			if not is_on_floor():
				velocity.y+=GRAVITY
			
		
		else:
			velocity.y+=GRAVITY
		velocity=move_and_slide(velocity,Vector2(0,-1))
		for i in get_slide_count():
			var collision=get_slide_collision(i)
			if collision and collision.collider.is_in_group("character"):
				collision.collider.damage(DAMAGE)
				knockback()
	elif alvo!=null:
		follow_checker()


func _on_Range_body_entered(body):
	if body.is_in_group("character"):
		alvo=body
		follow_checker()

func follow_checker():
	$RayCast2D.set_cast_to(alvo.global_position-global_position)
	$RayCast2D.force_raycast_update()
	if $RayCast2D.get_collider()==alvo:
		following=true
		$AnimationPlayer.play("walking")
	

func _on_Range_body_exited(body):
	if body.is_in_group("character"):
		alvo=null
		following=false
		not_jumped=true
		$AnimationPlayer.stop()

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
	$AnimationPlayer.play("dying")
	set_physics_process(false)
	$AttackRange.visible=false
	$Range.visible=false
	$CollisionShape2D.disabled=true


func _on_AttackRange_body_entered(body):
	attack()
	
func attack():
	if $Sprite.flip_h==true:
		$AnimationPlayer.play("attacking-right")
	else:
		$AnimationPlayer.play("attacking-left")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="attacking-right" or anim_name=="attacking-left":
		$AnimationPlayer.play("walking")


func _on_AttackLeft_body_entered(body):
	if body.is_in_group("character"):
		body.damage(ATTACK_DAMAGE)
		knockback()


func _on_AttackRight_body_entered(body):
	if body.is_in_group("character"):
		body.damage(ATTACK_DAMAGE)
		knockback()
