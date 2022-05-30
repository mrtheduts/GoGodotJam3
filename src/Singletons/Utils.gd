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
# Merges two dictionaries which values are ONLY arrays
#
func merge_dicts_of_arrays(dict_a: Dictionary, dict_b: Dictionary) -> Dictionary:
	var new_dict := {}
	var dicts = [dict_a, dict_b]
	for dict in dicts:
		dict = dict as Dictionary
		for key in dict.keys():
			if (not new_dict.has(key)):
				new_dict[key] = dict[key]
			else:
				new_dict[key] = new_dict[key] + dict[key]
	return new_dict
