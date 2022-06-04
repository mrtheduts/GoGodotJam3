#
# Utils.gd - Project-wide utils functions
#

extends Node

#
# Connects two objects and checks for any error
#
func conn_nodes(src_obj: Object,
		src_signal: String,
		dest_obj: Object,
		dest_func: String,
		binds: Array = [],
		flags: int = 0) -> void:

	if (!src_obj.is_connected(src_signal, dest_obj, dest_func)):
		var error := src_obj.connect(src_signal, dest_obj, dest_func, binds, flags)
		if (error):
			printerr("Error (" + String(error) + ") connecting " + src_signal + " to " + dest_func)
	else:
		printerr(src_signal + " is already connected to " + dest_func + " for objects: ", src_obj, " ", dest_obj)

#
# Shuffles and pops a random element from the Array
#
func shuffle_and_pop_front(array: Array):
	randomize()
	array.shuffle()
	return array.pop_front()

#
# Mixes an array colors
#
func mix_colors(colors: Array) -> Color:
	var final_color = null
	for color in colors:
		final_color = color if(final_color == null) \
			else final_color.linear_interpolate(color, 1/DNA.NUM_ALLELES as float)
	return final_color

#
# Returns a boolean for True or False strings
#
func as_bool(value: String) -> bool:
	return true if (value == "true") else false

#
# Merges two dictionaries which values are ONLY arrays
#
func merge_dicts_of_arrays(dict_a: Dictionary, dict_b: Dictionary, unique_values: bool = false) -> Dictionary:
	var new_dict := {}
	var dicts = [dict_a, dict_b]
	for dict in dicts:
		dict = dict as Dictionary
		for key in dict.keys():
			if (not new_dict.has(key)):
				new_dict[key] = dict[key]
			else:
				var res_array: Array = new_dict[key]
				if (unique_values):
					for value in dict[key]:
						if (not value in res_array):
							res_array.push_back(value)
				else:
					res_array += dict[key]
				new_dict[key] = res_array
	return new_dict

#
# Reparent a node from src to target
#
func reparent_node(node: Node, src: Node, target: Node) -> void:
	src.remove_child(node)
	target.add_child(node)
	node.set_owner(target)

#
# Returns a random integer between a and b
#
func randi_range(a: int, b: int) -> int:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi_range(a, b)
