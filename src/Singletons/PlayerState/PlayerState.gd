#
# PlayerState.gd - State for player accessible for entire game
#

extends Node

signal money_changed

var _money: int = 10
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
