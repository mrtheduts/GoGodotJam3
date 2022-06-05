extends CanvasLayer

class_name CombineAnimation

var rotation_speed : int = 50

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("mouse_leftbtn"):
			queue_free()
			
func _process(delta):
	$Lights/Light2D.rotation_degrees += delta * rotation_speed
	
func init(plant, center: Vector2):
	$Display/Seed.init_seed(plant)
	$Display/Seed.position = center
	$Lights/Light2D.position = center
