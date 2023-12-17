extends StaticBody3D

var Pressed=false

func interact():
	if Pressed==false:
		Pressed=true
		for i in range(17):
			$MeshInstance3D10.position.x=lerp($MeshInstance3D10.position.x,0.01,0.085)
			await get_tree().create_timer(0.01).timeout
		print("5")
		$"../Label3D".text=$"../Label3D".text+str(5)
		$"../AudioStreamPlayer".play()
		for i in range(17):
			$MeshInstance3D10.position.x=lerp($MeshInstance3D10.position.x,0.05,0.085)
			await get_tree().create_timer(0.01).timeout
		Pressed=false
