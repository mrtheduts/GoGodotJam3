#
# CloseUpPlant.gd
#

extends Node2D

class_name CloseUpPlant

var nodes_with_idle_animation := []


# Called when the node enters the scene tree for the first time.
func _ready():
	start_idle_animation()

func add_to_idle_animation_list(node: Node2D) -> void:
	nodes_with_idle_animation.push_back(node)

func start_idle_animation() -> void:
	for node in nodes_with_idle_animation:
		node.play_idle_animation()

func get_plant_center() -> Vector2:
	return Vector2(0, -150)
