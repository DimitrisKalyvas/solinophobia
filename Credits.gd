extends RichTextLabel

func _ready():
	await get_tree().create_timer(10).timeout
	for i in range(100):
		await get_tree().create_timer(0.1).timeout
		self_modulate.a=self_modulate.a-0.01
	queue_free()
