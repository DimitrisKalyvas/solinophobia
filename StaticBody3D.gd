extends StaticBody3D

var DoorStatus="Closed"
var AllowInteraction=true
var HoldTime=0


#func interact():
#	if (not($AnimationPlayer.is_playing()) and AllowInteraction==true):
#		if (DoorStatus=="Closed"):
#			DoorStatus="Open"
#			$AnimationPlayer.play("Open")
#		else:
#			DoorStatus="Closed"
#			$AnimationPlayer.play("Close")

func interact():
	print("hi")
	
#func on_raycast_A_object_hit(object):
	#if object == self:
		#print("hi222")
