extends Control


var coletados=[[false,false,false],[false,false,false]]
var equipados=[false,false]

func _process(delta):
	if coletados[0][0]:
		$MarginContainer/Node2D2/HBoxContainer/VBoxContainer/HBoxContainer/NinePatchRect/NinePatchRect.visible=true
	if coletados[0][1]:
		$MarginContainer/Node2D2/HBoxContainer/VBoxContainer2/HBoxContainer/NinePatchRect/NinePatchRect.visible=true
	if coletados[0][2]:
		$MarginContainer/Node2D2/HBoxContainer/VBoxContainer3/HBoxContainer/NinePatchRect/NinePatchRect.visible=true
	if coletados[1][0]:
		$MarginContainer/Node2D2/HBoxContainer/VBoxContainer/HBoxContainer2/NinePatchRect/NinePatchRect.visible=true
	if coletados[1][1]:
		$MarginContainer/Node2D2/HBoxContainer/VBoxContainer2/HBoxContainer2/NinePatchRect/NinePatchRect.visible=true
	if coletados[1][2]:
		$MarginContainer/Node2D2/HBoxContainer/VBoxContainer3/HBoxContainer2/NinePatchRect/NinePatchRect.visible=true
	
func change_life(new_life):
	$Tween.interpolate_property($MarginContainer/Node2D/LifeBar, "value",
		$MarginContainer/Node2D/LifeBar.value, new_life, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
