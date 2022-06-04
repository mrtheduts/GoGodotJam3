#
# CloseUpPlant.gd
#

extends Node2D

class_name CloseUpPlant

signal update_ui

const PLANT_OFFSET := Vector2(0, -150)
const DEPTH_SEED := Vector2(0, 100)
const DEPTH_SPROUT := Vector2(0, 50)

var _entry_points := {}
var nodes_with_idle_animation := []

var seed_node = null
var root_node = null
var stalk_node = null

var branch_nodes := []
var leaf_nodes := []
var flower_nodes := []
var fruit_nodes := []

var has_to_die := false

func _ready():
	if (has_to_die):
		has_to_die = false
		die()

func add_to_random_entry_point(node: Node) -> bool:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	
	var entry_attempts := []
	var is_node_added := false
	while (not is_node_added and _entry_points.keys().size() > entry_attempts.size()):
		var entries := _entry_points.keys()
		var entry_index := rng.randi_range(0, entries.size() - 1)
		var entry = entries[entry_index]
		
		if (not entry in entry_attempts):
			entry_attempts.push_back(entry)
			var entry_children: Array = _entry_points[entry]
			
			if (entry_children.size() < Constants.NUM_CHILDREN_PER_ENTRY):
				node.scale.x = -1 if (entry_children.size() == 1) else 1 # Flip any node to the left
				entry.add_child(node)
				entry_children.push_back(node)
				
				if (node is Leaf):
					leaf_nodes.push_back(node)
				elif (node is Branch):
					branch_nodes.push_back(node)
				
				var node_entry_points = node.get("_entry_points")
				if (node_entry_points != null):
					_entry_points = Utils.merge_dicts_of_arrays(_entry_points, node_entry_points)
				is_node_added = true
	
	return is_node_added

func erase_node(node: Node) -> void:
	for entry in _entry_points.keys():
		var entry_children: Array = _entry_points[entry]
		if (node in entry_children):
			entry_children.erase(node)
			entry.remove_child(node)
			node.queue_free()

func age() -> void:
	var nodes = [root_node, stalk_node] + branch_nodes
	for node in nodes:
		if (node and node.has_method("age")):
			node.age()
			if (node.get("_entry_points")):
				_entry_points = Utils.merge_dicts_of_arrays(_entry_points, node._entry_points, true)

func die() -> void:
	if (not self.is_inside_tree()):
		has_to_die = true
		return
	
	for entry in _entry_points.keys():
		var curr_children: Array = _entry_points[entry]
		var new_children := []
		for child in curr_children:
			var has_fallen: bool = child.die() if (child.has_method("die")) else false
			new_children.push_back(child)
		_entry_points[entry] = new_children
	
	var nodes = [root_node, stalk_node] + branch_nodes
	for node in nodes:
		if (node.has_method("die")):
			node.die()
			
	emit_signal("update_ui", Constants.LIFE_STAGES.DEAD)

func free_seed() -> void:
	nodes_with_idle_animation.erase(seed_node)
	seed_node.queue_free()
	seed_node = null
	
func add_seed(node: Node) -> void:
	self.seed_node = node
	add_child(node)

func add_root(node: Node) -> void:
	self.root_node = node
	stalk_node.get_stalk_down().add_child(node) # Fixed entry point for root

func add_stalk(node: Node) -> void:
	self.stalk_node = node
	add_child(stalk_node)
	_entry_points = Utils.merge_dicts_of_arrays(_entry_points, node._entry_points, true)

func erase_leaves(leaves: Array = leaf_nodes) -> void:
	for leaf in leaves:
		erase_node(leaf)
	for leaf in leaves:
		leaf_nodes.erase(leaf)

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
	
