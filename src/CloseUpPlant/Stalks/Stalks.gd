#
# Stalks.gd
#

extends Node2D

class_name Stalk

func start_wind_animation() -> void:
	$AnimationPlayer.play("Wind")

func add_to_skel_down(node: Node2D) -> void:
	$StalkSkeleton/SkelDown.add_child(node)

func add_to_skel_mid(node: Node2D) -> void:
	$StalkSkeleton/SkelDown/SkelMid.add_child(node)

func add_to_skel_up(node: Node2D) -> void:
	$StalkSkeleton/SkelDown/SkelMid/SkelUp.add_child(node)

func add_to_skel_top(node: Node2D) -> void:
	$StalkSkeleton/SkelDown/SkelMid/SkelUp/SkelTop.add_child(node)
