#
# Roots.gd
#

extends Node2D

class_name Root

func play_idle_animation() -> void:
	$AnimationPlayer.play("Idle")
