extends Node3D

var Pressed=false

func interact():
	if Pressed==false:
		Pressed=true
		for i in range(17):
			$ButtonInteractible.position.x=lerp($ButtonInteractible.position.x,0.01,0.085)
			await get_tree().create_timer(0.01).timeout
		print("BUTTON TEST")
		for i in range(17):
			$ButtonInteractible.position.x=lerp($ButtonInteractible.position.x,0.05,0.085)
			await get_tree().create_timer(0.01).timeout
		Pressed=false
