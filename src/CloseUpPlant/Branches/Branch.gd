#
# Branch.gd
#

extends Node2D

class_name Branch

func play_idle_animation() -> void:
	$AnimationPlayer.play("Idle")

func add_to_begin_bone(node: Node2D) -> void:
	$Skeleton2D/BeginBone.add_child(node)

func add_to_mid_bone(node: Node2D) -> void:
	$Skeleton2D/BeginBone/MidBone.add_child(node)

func add_to_end_bone(node: Node2D) -> void:
	$Skeleton2D/BeginBone/MidBone/EndBone.add_child(node)
