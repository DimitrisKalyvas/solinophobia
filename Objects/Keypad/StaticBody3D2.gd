extends StaticBody3D


var Pressed=false

func interact():
	if Pressed==false:
		Pressed=true
		for i in range(17):
			$MeshInstance3D8.position.x=lerp($MeshInstance3D8.position.x,0.01,0.085)
			await get_tree().create_timer(0.01).timeout
		print("3")
		$"../Label3D".text=$"../Label3D".text+str(3)
		$"../AudioStreamPlayer".play()
		for i in range(17):
			$MeshInstance3D8.position.x=lerp($MeshInstance3D8.position.x,0.05,0.085)
			await get_tree().create_timer(0.01).timeout
		Pressed=false
