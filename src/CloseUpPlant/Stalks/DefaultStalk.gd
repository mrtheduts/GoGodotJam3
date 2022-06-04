#
# Stalks.gd
#

extends Node2D

func set_age(age: int) -> void:
	match age:
		Constants.LIFE_STAGES.SPROUT:
			$AnimationPlayer.play("RESET")
			$Polygons/StalkDown.visible = true
			$Polygons/StalkMid.visible = false
			$Polygons/StalkUp.visible = false
		Constants.LIFE_STAGES.TEENAGE:
			$AnimationPlayer.play("RESET")
			$Polygons/StalkDown.visible = true
			$Polygons/StalkMid.visible = true
			$Polygons/StalkUp.visible = false
		Constants.LIFE_STAGES.ADULT:
			$AnimationPlayer.play("RESET")
			$Polygons/StalkDown.visible = true
			$Polygons/StalkMid.visible = true
			$Polygons/StalkUp.visible = true
		Constants.LIFE_STAGES.DEAD:
			$AnimationPlayer.play("Dead")

func play_idle_animation() -> void:
	$AnimationPlayer.play("Idle")

func get_stalk_down():
	return $StalkSkeleton/SkelDown

func get_stalk_mid():
	return $StalkSkeleton/SkelDown/SkelMid

func add_to_skel_down(node: Node2D) -> void:
	$StalkSkeleton/SkelDown.add_child(node)

func add_to_skel_mid(node: Node2D) -> void:
	$StalkSkeleton/SkelDown/SkelMid.add_child(node)

func add_to_skel_up(node: Node2D) -> void:
	$StalkSkeleton/SkelDown/SkelMid/SkelUp.add_child(node)

func add_to_skel_top(node: Node2D) -> void:
	$StalkSkeleton/SkelDown/SkelMid/SkelUp/SkelTop.add_child(node)
