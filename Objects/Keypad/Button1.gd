extends StaticBody3D

var Pressed=false

func interact():
	if Pressed==false:
		Pressed=true
		for i in range(17):
			$MeshInstance3D7.position.x=lerp($MeshInstance3D7.position.x,0.01,0.085)
			await get_tree().create_timer(0.01).timeout
		print("2")
		$"../Label3D".text=$"../Label3D".text+str(2)
		$"../AudioStreamPlayer".play()
		for i in range(17):
			$MeshInstance3D7.position.x=lerp($MeshInstance3D7.position.x,0.05,0.085)
			await get_tree().create_timer(0.01).timeout
		Pressed=false
