extends SpotLight3D

#await get_tree().create_timer(5).timeout Used for creating a timer :3
#int(randf_range(0,1)+0.3)

var Found=true #Turns true when the player finds it
var FlashLightState=true #True = ON / False = OFF (1/0)
var RandomValue=0 #used in LighterCondition()
var HitFatigue=false

func PickedUp():
	FlashLightState=true
	$Timer.start()
	
func _ready():
	$Timer.start() #Debug Purpose

func TurnON():
	light_energy=0.5
	await get_tree().create_timer(randf_range(0,0.2)).timeout
	for i in range(5):
		await get_tree().create_timer(randf_range(0,0.02)).timeout
		light_energy+=0.1

func _process(delta):
	if (FlashLightState==false && Input.is_action_just_pressed("FlashlightHit") && HitFatigue==false):
		HitFatigue=true
		$Timer2.start()
		RandomValue=int(randf_range(0,1)+0.5)
		if (RandomValue==1):
			$AudioStreamPlayer3D.play()
			TurnON()
			FlashLightState=true
			visible=true
			$Timer.wait_time=randf_range(4,8)
			$Timer.start()
		else:
			$AudioStreamPlayer3D.play()

func _on_timer_timeout():
	$Timer.wait_time=randf_range(4,8)
	LighterCondition()
	
func LighterCondition():
	for i in range(int(randf_range(25,85))):
		light_energy=randf_range(0,1)
		await get_tree().create_timer(randf_range(0,0.05)).timeout
	RandomValue=int(randf_range(0,1)+0.3)
	if (RandomValue==0):
		FlashLightState=false
		visible=false
	else:
		light_energy=1
		$Timer.wait_time=randf_range(4,8)
		$Timer.start()
		


func _on_timer_2_timeout():
	HitFatigue=false
