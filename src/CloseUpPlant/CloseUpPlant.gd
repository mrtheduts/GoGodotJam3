#
# CloseUpPlant.gd
#

extends Node2D

class_name CloseUpPlant

const PLANT_OFFSET := Vector2(0, -150)
const DEPTH_SEED := Vector2(0, 100)
const DEPTH_SPROUT := Vector2(0, 50)

var nodes_with_idle_animation := []

var seed_node = null
var root_node = null
var stalk_node = null

var leaf_nodes := []

func set_age(age: int) -> void:
	var nodes = [root_node, stalk_node]
	for node in nodes:
		node.set_age(age)

func free_seed() -> void:
	seed_node.queue_free()
	seed_node = null

func add_seed(node: Node) -> void:
	self.seed_node = node
	add_child(node)

func add_root(node: Node) -> void:
	self.root_node = node
	stalk_node.get_stalk_down().add_child(node)

func add_stalk(node: Node) -> void:
	self.stalk_node = node
	add_child(stalk_node)

func add_leaf(node: Node, parent: Node, scale: Vector2 = Vector2.ONE) -> void:
	node.scale = scale
	leaf_nodes.push_back(node)
	parent.add_child(node)

func move_seed_to_top() -> void:
	move_child(seed_node, get_child_count() - 1)

func add_to_idle_animation_list(node: Node2D) -> void:
	nodes_with_idle_animation.push_back(node)

func play_idle_animation() -> void:
	for node in nodes_with_idle_animation:
		node.play_idle_animation()

func set_depth_as(age: int) -> void:
	match age:
		Constants.LIFE_STAGES.SEED:
			position = DEPTH_SEED
		Constants.LIFE_STAGES.SPROUT:
			position = DEPTH_SPROUT
		_:
			position = Vector2.ZERO

func get_plant_center() -> Vector2:
	return PLANT_OFFSET - position / 20
	
