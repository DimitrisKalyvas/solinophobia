extends CharacterBody3D

#General Values
var speed
var gravity = 9.8
var MaxHealth=100 #Max Health
var Health=MaxHealth #Sets Health to MaxHealth

#Setting Values
var SENSITIVITY = 0.001

#Speed Values
const CROUTCH_SPEED = 1.2
const WALK_SPEED = 2.5
const SPRINT_SPEED = 6.0

#Sound Timer
var SoundTimer=10
var SoundFinished=true
var SoundDelay=0

const CROUTCH_DELAY=90
const WALK_DELAY=45
const SPRINT_DELAY=18

#Bools
var AllowPause=true #Allows pausing of the game
var AllowSprint=true #Enables Sprinting & controlled by sprinting
var AllowJump=false #Enables Jumping (unused for this project)
var AllowCroutch=true #Enables Croutching

#player states
var paused=false #Is game paused?
var Croutched=false #Is player croutched?
var Stalked=false #is the player being stalked?

#Stalked Flags
var StalkedSoundFlag=false

#head bob variables
var BOB_FREQ = 3.4
var BOB_AMP = 0.04 
var t_bob = 0.0
var TIME=Time.get_unix_time_from_system()

#FOV variables
const BASE_FOV = 75.0
const FOV_CHANGE = 0.4

#SIGNALS

#signal CurrentCollider

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var croutch_graphics = $Panel
@onready var soundplayer = $FootstepStreamer
@onready var collision = $CollisionShape3D
@onready var CroutchCollision = $CroutchCollision
@onready var HeadCollider = $Head/RayCast3D2
@onready var Interactor = $Head/Camera3D/RayCast3D

func TestStalking(): #Debug Function (can be removed)
	await get_tree().create_timer(7).timeout
	IsStalked()
	await get_tree().create_timer(7).timeout
	IsNotStalked()
	await get_tree().create_timer(7).timeout
	IsStalked()
	await get_tree().create_timer(7).timeout
	IsNotStalked()

func IsStalked():
	Stalked=true
	$Panel/TextureRect.modulate.a=0

func IsNotStalked():
	Stalked=false 
	$Panel/TextureRect.modulate.a=0 

func _ready(): #Setting up the player
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$InteractIcon.visible=false

func _unhandled_input(event):
	if (paused==false):
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * SENSITIVITY)
			camera.rotate_x(-event.relative.y * SENSITIVITY)
	if event is InputEventKey: #Pause/Unpause
		if Input.is_action_just_pressed("pause") and AllowPause==true:
			if (paused==true):
				Input.set_mouse_mode(2)
				paused=false
			else:
				Input.set_mouse_mode(0)
				paused=true
				
#func _process(delta): #Handles Gun PROTOTYPE
	#$Head/HandPosition/HandRig.set_as_top_level(true)
	#$Head/HandPosition/HandRig.global_transform.origin=$Head.global_transform.origin
	#$Head/HandPosition/HandRig.rotation.y=lerp_angle($Head/HandPosition/HandRig.rotation.y,$Head.rotation.y,0.15)
	#$Head/HandPosition/HandRig.rotation.x=lerp($Head/HandPosition/HandRig.rotation.x,camera.rotation.x+0.2,0.2)
	#$Head/HandPosition/HandRig/MeshInstance3D.rotation.y+=camera.position.y/4

func _physics_process(delta):
	camera.rotation.x=clamp(camera.rotation.x,-1.6,1.38) #was 1.6
	#print(DisplayServer.window_get_size().x)
		
	#Add gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	#Shows Interactible Icon
	if Interactor.get_collider()!=null:
		if Interactor.get_collider().is_in_group("Interactible"):
			#CurrentCollider(Interactor.get_collider())
			#(Interactor.get_collider()).emit()
			
			$InteractIcon.visible=true
		else:
			$InteractIcon.visible=false
	if Interactor.get_collider()==null:
		$InteractIcon.visible=false
	
	#Calls interact() function on the interactible
	if Input.is_action_just_pressed("Interact"):
		var collider = Interactor.get_collider()
		if collider!=null:
			if collider.is_in_group("Interactible"):
				collider.interact()
		
	#Handle Sprint.
	if Input.is_action_pressed("sprint") and AllowSprint==true:
		SoundDelay=SPRINT_DELAY
		soundplayer.volume_db=2
		soundplayer.pitch_scale=1
		speed = SPRINT_SPEED
		BOB_AMP = 0.06
	else:
		if Croutched==false:
			SoundDelay=WALK_DELAY
			soundplayer.volume_db=0
			soundplayer.pitch_scale=1
			speed = WALK_SPEED
			BOB_AMP = 0.04
			$ClothStreamer.volume_db=-10
			$ClothStreamer.pitch_scale=1.57
	
	#Handle Croutching
	if Input.is_action_just_pressed("croutch") and Croutched==false: #When first pressed
			HeadCollider.enabled=true
			$Effects.play()
			soundplayer.volume_db=-3
			$ClothStreamer.volume_db=-15
			$ClothStreamer.pitch_scale=0.8
			
	if Input.is_action_pressed("croutch") or HeadCollider.is_colliding()==true: #When held
		speed=CROUTCH_SPEED
		AllowSprint=false
		Croutched=true
		head.position.y=lerp(head.position.y,1.00,0.07)
		BOB_AMP = 0.02
		croutch_graphics.modulate=lerp(croutch_graphics.modulate,Color(0.5, 0.5, 0.5),0.05)
		CroutchCollision.disabled=false
		collision.disabled=true
		SoundDelay=CROUTCH_DELAY
	else:
		head.position.y=lerp(head.position.y,1.679,0.09) #The moment there's no obstruction
		croutch_graphics.modulate=lerp(croutch_graphics.modulate,Color(0, 0, 0),0.04)
		AllowSprint=true
		Croutched=false
		CroutchCollision.disabled=true
		collision.disabled=false
		HeadCollider.enabled=false
		
	if Input.is_action_just_released("croutch"): #When let go
		if HeadCollider.is_colliding()==false:
			$Effects.play()
	
	# Get the input direction and handle the movement/deceleration.
	if (paused==false):
		var input_dir = Input.get_vector("a", "d", "w", "s")
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if is_on_floor():
			if direction:
				#HANDLES WALKING SOUNDS & CLOTH SOUNDS
				if SoundFinished==true:
					if SoundTimer>=SoundDelay:
						soundplayer.play()
						$ClothStreamer.play()
						SoundTimer=0
					else:
						SoundTimer+=1
						
				#REST HANDLES MOVEMENT
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed
			else:
				velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
				velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	else: #In-case of pause set everything to 0
		velocity.x=0
		velocity.z=0
		
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos


func _on_audio_stream_player_finished():
	SoundFinished=true
	
