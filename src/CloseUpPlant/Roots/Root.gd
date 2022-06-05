#
# Roots.gd
#

extends Node2D

class_name Root

var life_stage = Constants.LIFE_STAGES.SPROUT

func _ready():
	z_index = Constants.Z_INDEX_ROOT

func age() -> void:
	$AnimationPlayer.play("RESET")
	match life_stage + 1:
		Constants.LIFE_STAGES.TEENAGE:
			life_stage += 1
			$Sprout.visible = false
			$Teenage.visible = true
		Constants.LIFE_STAGES.ADULT:
			life_stage += 1
			$Teenage.visible = false
			$Adult.visible = true

func die():
	$Tween.interpolate_property(
		self, "modulate",
		self.modulate, Constants.DEAD_COLOR, 
		Constants.DYING_DURATION, $Tween.TRANS_LINEAR, $Tween.EASE_OUT
	)
	$Tween.start()
	$AnimationPlayer.play("RESET")

func set_modulate_color(color: Color) -> void:
	for node in [$Sprout, $Teenage, $Adult]:
		node.modulate = color

func play_idle_animation() -> void:
	$AnimationPlayer.play("Idle")
