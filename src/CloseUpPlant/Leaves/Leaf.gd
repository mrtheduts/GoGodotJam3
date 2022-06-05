extends RigidBody2D

class_name Leaf

var has_fallen := false

func die():
	has_fallen = Utils.randi_range(0, 1)
	$Tween.interpolate_property(
		self, "modulate",
		self.modulate, Constants.DEAD_LEAF_COLOR, 
		Constants.DYING_DURATION, $Tween.TRANS_LINEAR, $Tween.EASE_OUT
	)
	$Tween.start()
	return has_fallen


func _on_Tween_tween_all_completed():
	if (has_fallen):
		mode = RigidBody2D.MODE_RIGID
