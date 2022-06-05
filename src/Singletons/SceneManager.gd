extends Node

var _saved_scene: Node

func change_scene(scene: Node):
	var root_node = get_node("/root")
	var tree = get_tree()
	_saved_scene = get_tree().get_current_scene()
	root_node.add_child(scene)
	root_node.remove_child(_saved_scene)
	tree.set_current_scene(scene)

func pop_scene():
	var root_node = get_node("/root")
	var tree = get_tree()
	var this_scene = tree.get_current_scene()
	root_node.remove_child(this_scene)
	this_scene.call_deferred("free")
	root_node.add_child(_saved_scene)
	tree.set_current_scene(_saved_scene)
