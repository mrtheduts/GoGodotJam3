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

# 
# Creates a dictionary for each probability in an array of weights.
# The resulting array of dicts can be used for the init_probabilities function.
#
func create_prob_dicts(weights: Array) -> Array:
	var dict_arr = []
	for prob in weights:
		dict_arr.append({"roll_weight": prob, "acc_weight": INF})
	return dict_arr

#
# Init Probabilities for Weighted Random Choices
# Adds the accumulated weight to each object with a roll weight
#
# Requires an array of dictionaries which contain "roll_weight" and "acc_weight".
#
func init_probabilities(object_types: Array) -> float:
	# Reset total_weight to make sure it holds the correct value after initialization
	var total_weight = 0.0
	# Iterate through the objects
	for obj_type in object_types:
		# Take current object weight and accumulate it
		total_weight += obj_type.roll_weight
		# Take current sum and assign to the object.
		obj_type.acc_weight = total_weight
	return total_weight

#
# Picks a random object from an array with weights
# Needs to have the total weight calculated by the init_probabilities function.
#
# Requires an array of dictionaries which contain "roll_weight" and "acc_weight".
# Returns the index of the object in the array.
#
func weighted_random_object(object_types: Array, total_weight: float) -> int:
	# Roll the number
	var roll: float = rand_range(0.0, total_weight)
	# Now search for the first with acc_weight > roll
	for i in range(object_types.size()):
		if (object_types[i].acc_weight > roll):
			return i
			
	# If here, something weird happened, but the function has to return an int.
	return -1
