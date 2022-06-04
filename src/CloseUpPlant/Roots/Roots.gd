#
# Roots.gd
#

extends Node2D

func set_age(age: int) -> void:
	match age:
		Constants.LIFE_STAGES.SPROUT:
			$AnimationPlayer.play("RESET")
			$Sprout.visible = true
			$Adult.visible = false
		Constants.LIFE_STAGES.TEENAGE:
			$AnimationPlayer.play("RESET")
			$Sprout.visible = false
			$Adult.visible = false
		Constants.LIFE_STAGES.ADULT:
			$AnimationPlayer.play("RESET")
			$Sprout.visible = false
			$Adult.visible = true
		Constants.LIFE_STAGES.DEAD:
			$AnimationPlayer.play("Dead")

func die():
	$AnimationPlayer.stop()

func play_idle_animation() -> void:
	$AnimationPlayer.play("Idle")
