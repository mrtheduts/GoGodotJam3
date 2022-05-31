#
# Roots.gd
#

extends Node2D

class_name Root

func start_idle_animation() -> void:
	$AnimationPlayer.play("Idle")
