#
# Roots.gd
#

extends Node2D

func start_idle_animation() -> void:
	$AnimationPlayer.play("Idle")
