#
# PlayerState.gd - State for player accessible for entire game
#

extends Node

signal money_changed
signal inventory_changed

var _money: int = 420
var _stored_plants: Array = []

var _inventory : Dictionary = {}
var _inventory_max_slots : int = 10

func _ready():
	if _inventory.empty():
		var dict:Dictionary = {}
		for slot in range (0, _inventory_max_slots):
			dict[String(slot)] = inventory_empty_slot()
		_inventory = dict

	
func set_money(value: int) -> void:
	_money = value
	emit_signal("money_changed", _money)
func get_money() -> int:
	return _money

func add_money(value: int) -> void:
	_money += value
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
		"stored_plants" : _stored_plants,
		"inventory" : _inventory
	}
	return save_dict
	
func load_stats(stats):
	print("LOADING STATS PLAYER")
	print(stats)
	_money = stats.money
	_stored_plants = stats.stored_plants

func _on_UILayer_plant_sold(value: int):
	add_money(value)
	
func inventory_add_item(item_id: int):
	# Get Item Data
	var item_data : Dictionary = ItemDatabase.get_item(String(item_id))
	var slot : int = -1

	if !item_data.empty():
		# If the item is not stackable, get an empty space for it
		if int(item_data["stack_limit"]) <= 1:
			slot = inventory_get_empty_slot()
			
			if slot < 0:
				emit_signal("inventory_changed", slot)
				return
				
			_inventory[String(slot)] = {"id": String(item_id), "amount": 1}
		else:
			# Check if the same item is already in inventory and if it can be stacked	
			for item_slot in range (0, _inventory_max_slots):
				if _inventory[String(item_slot)]["id"] == String(item_id):
					if int(item_data["stack_limit"]) > int(_inventory[String(item_slot)]["amount"]):
						_inventory[String(item_slot)]["amount"] = int(_inventory[String(item_slot)]["amount"] + 1)
						emit_signal("inventory_changed", item_slot)
						return
			
			# If the item can't be stacked to another, get an empty slot for it
			slot = inventory_get_empty_slot()
			
			if slot < 0:
				emit_signal("inventory_changed", slot)
				return
				
			_inventory[String(slot)] = {"id": String(item_id), "amount": 1}
	
	emit_signal("inventory_changed", slot)
	return
	
func inventory_get_item(slot: int) -> Dictionary:
	return _inventory[String(slot)]

func inventory_get_empty_slot() -> int:
	for slot in range(0, _inventory_max_slots):
		if _inventory[String(slot)]["id"] == "0": 
			return int(slot)
	print ("Inventory is full!")
	return -1

func inventory_update_item(slot: int, new_id: int, new_amount: int):
	if slot < 0:
		return
		
	if new_amount < 0:
		return
		
	if ItemDatabase.get_item(String(new_id)).empty():
		return
		
	_inventory[String(slot)] = {"id": String(new_id), "amount": int(new_amount)}

func inventory_sell_item(item_slot: int, sell_amount: int):
	if item_slot < 0:
		return
	
	if sell_amount < 0:
		return
		
	var sell_price : int = ItemDatabase.get_item(_inventory[String(item_slot)]["id"])["sell_price"]
	var current_amount : int = _inventory[String(item_slot)]["amount"]
	
	if sell_amount > current_amount:
		sell_amount = current_amount
	
	var new_amount = current_amount - sell_amount
	var new_money = _money + sell_amount * sell_price
	
	if new_amount == 0:
		inventory_update_item(item_slot, 0, 0)
	else:
		inventory_update_item(item_slot, int(_inventory[String(item_slot)]["id"]), new_amount)
		
	set_money(new_money)
	
func inventory_merge_item(from_slot: int, to_slot: int):
	if from_slot < 0 or to_slot < 0:
		return
	
	var from_data : Dictionary = _inventory[String(from_slot)]
	var to_data : Dictionary = _inventory[String(to_slot)]
		
	var to_stack_limit : int = ItemDatabase.get_item(_inventory[String(to_slot)]["id"])["stack_limit"]
	
	if from_data["id"] != to_data["id"]:
		return
		
	if int(to_data["amount"]) >= to_stack_limit:
		if int(from_data["amount"]) == 1:
			inventory_move_stack(from_slot, to_slot)
		return
	
	var to_new_amount : int = to_data["amount"] + 1
	var from_new_amount : int = from_data["amount"] - 1
	
	if to_new_amount > to_stack_limit and from_data["amount"] == 1:
		if int(from_data["amount"]) == 1:
			inventory_move_stack(from_slot, to_slot)
	else:
		inventory_update_item(to_slot, int(_inventory[String(to_slot)]["id"]), to_new_amount)
		if from_new_amount > 0:
			inventory_update_item(from_slot, int(_inventory[String(from_slot)]["id"]), from_new_amount)
		else:
			inventory_update_item(from_slot, 0, 0)
		
func inventory_merge_stack(from_slot: int, to_slot: int):
	if from_slot < 0 or to_slot < 0:
		return
	
	var from_data : Dictionary = _inventory[String(from_slot)]
	var to_data : Dictionary = _inventory[String(to_slot)]
	
	var to_stack_limit : int = ItemDatabase.get_item(_inventory[String(to_slot)]["id"])["stack_limit"]
	var from_stack_limit : int = ItemDatabase.get_item(_inventory[String(from_slot)]["id"])["stack_limit"]
	
	if to_stack_limit <= 1 or from_stack_limit <= 1:
		return
	
	if from_data["id"] != to_data["id"]:
		return
		
	if int(to_data["amount"]) >= to_stack_limit or int(from_data["amount"]) >= to_stack_limit:
		inventory_move_stack(from_slot, to_slot)
		return
	
	var to_new_amount : int = to_data["amount"] + from_data["amount"]
	var from_new_amount : int = 0
	
	if to_new_amount > to_stack_limit:
		from_new_amount = to_new_amount - to_stack_limit
		inventory_update_item(to_slot, int(_inventory[String(to_slot)]["id"]), to_stack_limit)
		inventory_update_item(from_slot, int(_inventory[String(from_slot)]["id"]), from_new_amount)
	else:
		inventory_update_item(to_slot, int(_inventory[String(to_slot)]["id"]), to_new_amount)
		inventory_update_item(from_slot, 0, 0)
		
		
func inventory_move_item(from_slot: int, to_slot: int):
	if _inventory[String(from_slot)]["amount"] > 1:
		# To Slot is empty
		if _inventory[String(to_slot)]["id"] == "0":
			_inventory[String(from_slot)]["amount"] -= 1
			inventory_update_item(to_slot, int(_inventory[String(from_slot)]["id"]), 1)
		else:
			var temp_item : Dictionary = _inventory[String(to_slot)]
			var new_to_slot = inventory_get_empty_slot()
			
			if new_to_slot >= 0: 
				_inventory[String(from_slot)]["amount"] -= 1
				_inventory[String(to_slot)] = inventory_empty_slot()
				inventory_update_item(to_slot, int(_inventory[String(from_slot)]["id"]), 1)
				_inventory[String(new_to_slot)] = temp_item
			return new_to_slot
	else:
		inventory_move_stack(from_slot, to_slot)
		
	return -1

func inventory_move_stack(from_slot: int, to_slot: int):
	var temp_item : Dictionary = _inventory[String(to_slot)]
	
	_inventory[String(to_slot)] = _inventory[String(from_slot)]
	_inventory[String(from_slot)] = temp_item
	
func inventory_empty_slot() -> Dictionary:
	return {"id": "0", "amount": 0}
