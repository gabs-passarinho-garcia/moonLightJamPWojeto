extends KinematicBody2D


var SPEED=450
var GRAVITY=1200
var JUMPSPEED=600
var velocity=Vector2()
var has_double_jump=true
var life=100
var itens = []
var double_jump_cost=10
var is_dano = false
var wall_jump_cost=5
var has_wall_jump=true
var melee_atack_cost = 5
var KNOCKBACK_ANGLE=PI/4
var KNOCKBACK_SPEED=1000
onready var espadaDir = $Espada
onready var espadaEsq = $Espada2
var ataque = false
var pulando = false
var pParade = false
var dano = false
var direita = true
func _ready():
	espadaDir.connect("body_entered",self,"atack")
	espadaEsq.connect("body_entered",self,"atack")
	set_physics_process(true)
	life = Global.life
	itens = Global.itens
	pass # Replace with function body.

func _physics_process(delta):
	
	if Input.is_action_pressed("ui_cancel"):
		$CanvasLayer/Pause_menu.visible = true
		$CanvasLayer/Pause_menu/AudioStreamPlayer2D.play()
		get_tree().paused = true
		pass
	if Input.is_action_just_pressed("melee_atack"):
		ataque = true
		damage(melee_atack_cost)
		if direita:
			$AnimationPlayer.play("golpeEspadaDireita")
		else:
			$AnimationPlayer.play("golpeEspadaEsquerda")
		pass
	if Input.is_action_pressed("left") and $WallJumpTimer.is_stopped():
		velocity.x=-SPEED
		if (direita == true) and (not ataque):
			for i in get_tree().get_nodes_in_group("characterSprite"):
				i.flip_h = true
			$wall_jump.position.x = -4
		if is_on_floor():
			if (not ataque) and (not pulando) and (not pParade) and (not dano):
				$AnimationPlayer.play("andando")
			#$Espada/Sprite.flip_h = true
		direita = false
	elif Input.is_action_pressed("right" ) and $WallJumpTimer.is_stopped():
		velocity.x=SPEED
		if (direita == false) and (not ataque):
			for i in get_tree().get_nodes_in_group("characterSprite"):
				i.flip_h = false
			$wall_jump.position.x = 12
		if is_on_floor():
			if (not ataque) and (not pulando) and (not pParade) and (not dano):
				$AnimationPlayer.play("andando")
			#$Espada/Sprite.flip_h = false
		direita = true
	elif $WallJumpTimer.is_stopped():
		velocity.x=0
		if (not ataque) and (not pulando) and (not pParade) and (not dano):
			$AnimationPlayer.play("parado")
	if Input.is_action_just_pressed("jump") :
		if is_on_floor():
			$AnimationPlayer.play("pulo")
			pulando = true
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
	$AnimationPlayer.play("pulo")
	pulando = true
	damage(double_jump_cost)

func wall_jump():
	if velocity.x!=0 and has_wall_jump:
		velocity.y=-JUMPSPEED
		velocity.x=-velocity.x
		$WallJumpTimer.start()
		damage(wall_jump_cost)
		has_wall_jump=false
		pParade = true
		$AnimationPlayer.play("puloParede")
		for i in get_tree().get_nodes_in_group("characterSprite"):
			i.flip_h = (not i.flip_h)
		direita = not direita
		if $wall_jump.position.x == -4:
			$wall_jump.position.x = 12
		else:
			$wall_jump.position.x = -4
			pass
func damage(damage, attack = false):
	if is_dano:
		return
	if attack:
		knockback()
		$AnimationPlayer.play("dano")
	life-=damage
	#print("dano =",damage)
	$CanvasLayer2/Control.change_life(life)
	if life<0:
		$MorteSom.play()
		Loading.goto_scene("res://Scenes/menus/Game_over.tscn")
		
func atack(body):
	if (body.is_in_group("enemy")):
		body.hit()
		pass
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	ataque = false
	pulando = false
	pParade = false
	dano = false
	pass # Replace with function body.

func get_Item(item):
	if not (item in itens):
		itens.append(item)
		pass
	pass

func knockback():
	$KnockbackTimer.start()
	is_dano=true
	if velocity.x>0:
		velocity=Vector2(0,-1).rotated(KNOCKBACK_ANGLE)*KNOCKBACK_SPEED
	else:
		velocity=Vector2(0,-1).rotated(-KNOCKBACK_ANGLE)*KNOCKBACK_SPEED


func _on_KnockbackTimer_timeout():
	is_dano=false
	pass # Replace with function body.


