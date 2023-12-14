extends MeshInstance3D



func _ready():
	await get_tree().create_timer(5).timeout
	$AudioStreamPlayer3D2.play()
	await get_tree().create_timer(50).timeout
	visible=false
