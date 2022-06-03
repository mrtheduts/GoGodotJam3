extends Node2D

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
