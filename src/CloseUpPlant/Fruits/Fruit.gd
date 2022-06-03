extends Node2D

class_name Fruit

func set_color(color: Color) -> void:
	$RigidBodyFruit/Polygon2D.modulate = color
