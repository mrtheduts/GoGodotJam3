#
# PlayerState.gd - State for player accessible for entire game
#

extends Node

signal money_changed

var _money: int = 150
var _stored_plants: Array = []
	
func set_money(value: int) -> void:
	_money = value
	emit_signal("money_changed", _money)

func store_plant(plant: Node2D) -> bool:
	var has_space: bool = Constants.STARTING_STORAGE_SPACE > _stored_plants.size()
	if (has_space):
		_stored_plants.push_back(plant)
	return has_space

func pop_stored_plant() -> Node2D:
	return _stored_plants.pop_front()

func save_stats():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"money" : _money,
		"stored_plants" : _stored_plants
	}
	return save_dict
	
func load_stats(stats):
	print("LOADING STATS PLAYER")
	print(stats)
	_money = stats.money
	_stored_plants = stats.stored_plants
