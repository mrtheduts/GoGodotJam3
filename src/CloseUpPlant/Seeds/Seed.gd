#
# Seed.gd
#

extends Node2D

class_name Seed

func _ready() -> void:
	randomize()
	self.rotation = rand_range(0, 2*PI)

func set_type(type: int) -> void:
	match type:
		DNA.SEED_TYPE_VALUES.BEAN:
			$Bean.visible = true
		DNA.SEED_TYPE_VALUES.FALL:
			$Fall.visible = true
		DNA.SEED_TYPE_VALUES.UNIT:
			$Unit.visible = true
		DNA.SEED_TYPE_VALUES.GRAIN:
			$Grain.visible = true
		DNA.SEED_TYPE_VALUES.GRAVITY:
			$Gravity.visible = true
		DNA.SEED_TYPE_VALUES.DRY:
			$Dry.visible = true

func play_idle_animation() -> void:
	$AnimationPlayer.play("Idle")
