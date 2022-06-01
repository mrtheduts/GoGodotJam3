extends Node2D

class_name Flower

func set_color(color: Color) -> void:
	$Polygon2D.modulate = color
