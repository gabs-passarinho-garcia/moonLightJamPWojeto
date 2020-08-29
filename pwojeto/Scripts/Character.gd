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
var melee_atack_cost = 1
onready var espadaDir = $Espada
onready var espadaEsq = $Espada2
var direita = true
func _ready():
	espadaDir.connect("body_entered",self,"atack")
	espadaEsq.connect("body_entered",self,"atack")
	set_physics_process(true)
	life = Global.life
	pass # Replace with function body.

func _physics_process(delta):
	
	if Input.is_action_pressed("ui_cancel"):
		$CanvasLayer/Pause_menu.visible = true
		get_tree().paused = true
		pass
	if Input.is_action_pressed("melee_atack"):
		if direita:
			$AnimationPlayer.play("golpeEspadaDireita")
		else:
			$AnimationPlayer.play("golpeEspadaEsquerda")
		pass
	if Input.is_action_pressed("left") and $WallJumpTimer.is_stopped():
		velocity.x=-SPEED
		if $Sprite.flip_h==false:
			$Sprite.flip_h=true
			#$Espada/Sprite.flip_h = true
		direita = false
	elif Input.is_action_pressed("right" ) and $WallJumpTimer.is_stopped():
		velocity.x=SPEED
		if $Sprite.flip_h==true:
			$Sprite.flip_h=false
			#$Espada/Sprite.flip_h = false
		direita = true
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
func damage(damage, attack = false):
	if attack:
		$AudioStreamPlayer2D2.play()
	life-=damage
	if life<0:
		get_tree().change_scene("res://Scenes/menus/Game_over.tscn")
		queue_free()
		
func atack(body):
	if (body.is_in_group("enemy")):
		body.hit()
		damage(melee_atack_cost)
		pass
	pass
