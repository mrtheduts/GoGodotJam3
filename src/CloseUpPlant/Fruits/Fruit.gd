extends Node2D

class_name Fruit

var has_fallen := false

func _ready():
	$RigidBodyFruit/CollisionShape2D2.set_deferred("disabled", false)
	z_index = Constants.Z_INDEX_FRUIT

func die():
	has_fallen = Utils.randi_range(0, 1)
	$Tween.interpolate_property(
		self, "modulate",
		self.modulate, Constants.DEAD_LEAF_COLOR, 
		Constants.DYING_DURATION, $Tween.TRANS_LINEAR, $Tween.EASE_OUT
	)
	$Tween.start()
	return has_fallen

func set_color(color: Color) -> void:
	$RigidBodyFruit/Polygon2D.modulate = color


func _on_Tween_tween_all_completed():
	if (has_fallen):
		$StaticBodyHolder.mode = RigidBody2D.MODE_RIGID
