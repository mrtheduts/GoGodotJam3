#
# Branch.gd
#

extends Node2D

class_name Branch

var _entry_points := {}

var life_stage = Constants.LIFE_STAGES.TEENAGE

func _ready():
	_entry_points[$Skeleton2D/BeginBone/MidBone] = []

func age() -> void:
	print("Aging branch to: ", life_stage + 1)
	$AnimationPlayer.play("RESET")
	match life_stage + 1:
		Constants.LIFE_STAGES.ADULT:
			life_stage += 1
			_entry_points[$Skeleton2D/BeginBone/MidBone/EndBone] = []
			$Teenage.visible = false
			$Adult.visible = true
	
	for entry in _entry_points.keys():
		var curr_children: Array = _entry_points[entry]
		for child in curr_children:
			if (child.has_method("age")):
				child.age()

func die():
	$AnimationPlayer.play("Dead")
	return false

func get_mid_bone():
	return $Skeleton2D/BeginBone/MidBone

func get_end_bone():
	return $Skeleton2D/BeginBone/MidBone/EndBone

func play_idle_animation() -> void:
	$AnimationPlayer.play("Idle")

func add_to_begin_bone(node: Node2D) -> void:
	$Skeleton2D/BeginBone.add_child(node)

func add_to_mid_bone(node: Node2D) -> void:
	$Skeleton2D/BeginBone/MidBone.add_child(node)

func add_to_end_bone(node: Node2D) -> void:
	$Skeleton2D/BeginBone/MidBone/EndBone.add_child(node)
