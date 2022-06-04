#
# Stalks.gd
#

extends Node2D

class_name Stalk

var life_stage = Constants.LIFE_STAGES.SPROUT

var root = null

var _entry_points := {}

func init_entry_points():
	_entry_points[$StalkSkeleton/SkelDown/SkelMid] = []


func age() -> void:
	$AnimationPlayer.play("RESET")
	match life_stage + 1:
		Constants.LIFE_STAGES.TEENAGE:
			life_stage += 1
			_entry_points[$StalkSkeleton/SkelDown/SkelMid/SkelUp] = []
			$Polygons/StalkMid.visible = true
		Constants.LIFE_STAGES.ADULT:
			life_stage += 1
			_entry_points[$StalkSkeleton/SkelDown/SkelMid/SkelUp/SkelTop] = []
			$Polygons/StalkUp.visible = true
	
	for entry in _entry_points.keys():
		var curr_children: Array = _entry_points[entry]
		for child in curr_children:
			if (child.has_method("age")):
				child.age()


func die():
	$Tween.interpolate_property(
		self, "modulate",
		self.modulate, Constants.DEAD_COLOR, 
		Constants.DYING_DURATION, $Tween.TRANS_LINEAR, $Tween.EASE_OUT
	)
	$AnimationPlayer.play("Dead")
	if (root != null and root.get("die")):
		root.die()
	$Tween.start()

func play_idle_animation() -> void:
	$AnimationPlayer.play("Idle")

func get_stalk_down():
	return $StalkSkeleton/SkelDown

func get_stalk_mid():
	return $StalkSkeleton/SkelDown/SkelMid

func get_stalk_up():
	return $StalkSkeleton/SkelDown/SkelMid/SkelUp

func add_to_skel_down(node: Node2D) -> void:
	$StalkSkeleton/SkelDown.add_child(node)

func add_to_skel_mid(node: Node2D) -> void:
	$StalkSkeleton/SkelDown/SkelMid.add_child(node)

func add_to_skel_up(node: Node2D) -> void:
	$StalkSkeleton/SkelDown/SkelMid/SkelUp.add_child(node)

func add_to_skel_top(node: Node2D) -> void:
	$StalkSkeleton/SkelDown/SkelMid/SkelUp/SkelTop.add_child(node)
