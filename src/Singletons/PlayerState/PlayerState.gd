#
# PlayerState.gd - State for player accessible for entire game
#

extends Node

signal money_changed
signal inventory_changed
signal edit_garden_mode
signal planting_mode

var _money: int = 250
var _stored_plants: Array = []

var _inventory : Dictionary = {}
var _inventory_max_slots : int = 10
var _holding_item : int = -1
var _sell_per : float = 0.75

var _shop_items : Array = []
var _shop_can_restock : bool = true

# Game goal variables
# Handles the plant list of the objective and its status (collected or not)
var _plant_goal_list: Array = []
var _plant_goal_status: Dictionary = {}

onready var _is_editing_garden : bool = false
onready var _is_planting_seed : bool = false

func _ready():
	Utils.conn_nodes(WorldManager, "new_day", self, "_on_WorldManager_new_day")
	if _inventory.empty():
		var dict:Dictionary = {}
		for slot in range (0, _inventory_max_slots):
			dict[String(slot)] = inventory_empty_slot()
		_inventory = dict
	
	if _plant_goal_list.empty():
		for _i in range(Constants.INDEX_ENTRIES):
			var plant = PlantFactory.gen_random_plant()
			_plant_goal_list.append(plant)
			_plant_goal_status[plant.phenotype_hash] = false
	
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
		"inventory" : _inventory,
		"goal_plants" : _plant_goal_list,
		"goal_status" : _plant_goal_status
	}
	return save_dict
	
func load_stats(stats):
	print("LOADING STATS PLAYER")
	print(stats)
	_money = stats.money
	_stored_plants = stats.stored_plants
	_inventory = stats.inventory
	_plant_goal_list = stats.goal_plants
	_plant_goal_status = stats.goal_status

func _on_UILayer_plant_sold(value: int):
	add_money(value)
	
func _on_WorldManager_new_day():
	_shop_can_restock = true

func hold_item_used():
	if _holding_item < 0:
		return
		
	var item = inventory_get_item(_holding_item)
	
	var new_amount = item["amount"] - 1
	
	if new_amount == 0:
		inventory_update_item(_holding_item, 0, 0, null)
	else:
		inventory_update_item(_holding_item, int(item["id"]), new_amount, item["seed_obj"])
	
	emit_signal("inventory_changed", _holding_item)
	hold_item_cancel()

func hold_item_cancel():
	_holding_item = -1
	
	if _is_planting_seed:
		_is_planting_seed = false
		emit_signal("planting_mode", false)
	
	if _is_editing_garden:
		_is_editing_garden = false
		emit_signal("edit_garden_mode", false)
	
func inventory_use_item(item_slot: int):
	var item = inventory_get_item(item_slot)
	
	if item["id"] == String(Constants.SEED_ITEM_ID) and !_is_editing_garden:
		_holding_item = item_slot
		_is_planting_seed = true
		emit_signal("planting_mode", true)
	elif item["id"] == String(Constants.HOE_ITEM_ID) and !_is_planting_seed:
		_holding_item = item_slot
		_is_editing_garden = true
		emit_signal("edit_garden_mode", true)
	
func inventory_add_item(item_id: int, add_amount: int = 1, seed_obj: Plant = null):
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
			
			_inventory[String(slot)] = {"id": String(item_id), "amount": add_amount, "seed_obj": null}
		else:
			# Check if the same item is already in inventory and if it can be stacked	
			for item_slot in range (0, _inventory_max_slots):
				if _inventory[String(item_slot)]["id"] == String(item_id):
					if _inventory[String(item_slot)]["seed_obj"] == null or PlantFactory.are_plants_equal(_inventory[String(item_slot)]["seed_obj"], seed_obj):
						if int(item_data["stack_limit"]) >= int(_inventory[String(item_slot)]["amount"]) + add_amount:
							_inventory[String(item_slot)]["amount"] = int(_inventory[String(item_slot)]["amount"] + add_amount)
							emit_signal("inventory_changed", item_slot)
							return
			
			# If the item can't be stacked to another, get an empty slot for it
			slot = inventory_get_empty_slot()
			
			if slot < 0:
				emit_signal("inventory_changed", slot)
				return
				
			_inventory[String(slot)] = {"id": String(item_id), "amount": add_amount, "seed_obj": seed_obj}
	
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

func inventory_update_item(slot: int, new_id: int, new_amount: int, seed_obj: Plant = null):
	if slot < 0:
		return
		
	if new_amount < 0:
		return
		
	if ItemDatabase.get_item(String(new_id)).empty():
		return
		
	if new_id == Constants.SEED_ITEM_ID and seed_obj == null:
		return
		
	_inventory[String(slot)] = {"id": String(new_id), "amount": int(new_amount), "seed_obj": seed_obj}

func inventory_sell_item(item_slot: int, sell_amount: int):
	if item_slot < 0:
		return
	
	if sell_amount < 0:
		return
	
	var item_data : Dictionary = _inventory[String(item_slot)]
	
	var sell_price : int = 0
	if item_data["id"] == String(Constants.SEED_ITEM_ID):
		# warning-ignore:narrowing_conversion
		sell_price = round(item_data["seed_obj"].value * _sell_per)
	else:
		# warning-ignore:narrowing_conversion
		sell_price = round(ItemDatabase.get_item(item_data["id"])["sell_price"] * _sell_per)
		
	var current_amount : int = item_data["amount"]
	
	if sell_amount > current_amount:
		sell_amount = current_amount
	
	var new_amount = current_amount - sell_amount
	var new_money = _money + sell_amount * sell_price
	
	if new_amount == 0:
		inventory_update_item(item_slot, 0, 0, null)
	else:
		inventory_update_item(item_slot, int(item_data["id"]), new_amount, item_data["seed_obj"])
		
	set_money(new_money)
	
func inventory_merge_item(from_slot: int, to_slot: int):
	if from_slot < 0 or to_slot < 0:
		return
	
	var from_data : Dictionary = _inventory[String(from_slot)]
	var to_data : Dictionary = _inventory[String(to_slot)]
		
	var to_stack_limit : int = ItemDatabase.get_item(_inventory[String(to_slot)]["id"])["stack_limit"]
	
	if from_data["id"] != to_data["id"]:
		inventory_move_stack(from_slot, to_slot)
		
	if from_data["id"] == String(Constants.SEED_ITEM_ID) and !PlantFactory.are_plants_equal(from_data["seed_obj"], to_data["seed_obj"]):
		inventory_move_stack(from_slot, to_slot)
		
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
		inventory_update_item(to_slot, int(_inventory[String(to_slot)]["id"]), to_new_amount, _inventory[String(to_slot)]["seed_obj"])
		if from_new_amount > 0:
			inventory_update_item(from_slot, int(_inventory[String(from_slot)]["id"]), from_new_amount, _inventory[String(from_slot)]["seed_obj"])
		else:
			inventory_update_item(from_slot, 0, 0, null)
		
func inventory_merge_stack(from_slot: int, to_slot: int):
	if from_slot < 0 or to_slot < 0:
		return
	
	var from_data : Dictionary = _inventory[String(from_slot)]
	var to_data : Dictionary = _inventory[String(to_slot)]
	
	var to_stack_limit : int = ItemDatabase.get_item(_inventory[String(to_slot)]["id"])["stack_limit"]
	var from_stack_limit : int = ItemDatabase.get_item(_inventory[String(from_slot)]["id"])["stack_limit"]
	
	if to_stack_limit <= 1 or from_stack_limit <= 1:
		inventory_move_stack(from_slot, to_slot)
	
	if from_data["id"] != to_data["id"]:
		inventory_move_stack(from_slot, to_slot)
		
	if from_data["id"] == String(Constants.SEED_ITEM_ID) and !PlantFactory.are_plants_equal(from_data["seed_obj"], to_data["seed_obj"]):
		inventory_move_stack(from_slot, to_slot)
		
	if int(to_data["amount"]) >= to_stack_limit or int(from_data["amount"]) >= to_stack_limit:
		inventory_move_stack(from_slot, to_slot)
		return
	
	var to_new_amount : int = to_data["amount"] + from_data["amount"]
	var from_new_amount : int = 0
	
	if to_new_amount > to_stack_limit:
		from_new_amount = to_new_amount - to_stack_limit
		inventory_update_item(to_slot, int(_inventory[String(to_slot)]["id"]), to_stack_limit, _inventory[String(to_slot)]["seed_obj"])
		inventory_update_item(from_slot, int(_inventory[String(from_slot)]["id"]), from_new_amount, _inventory[String(from_slot)]["seed_obj"])
	else:
		inventory_update_item(to_slot, int(_inventory[String(to_slot)]["id"]), to_new_amount, _inventory[String(to_slot)]["seed_obj"])
		inventory_update_item(from_slot, 0, 0, null)
		
		
func inventory_move_item(from_slot: int, to_slot: int):
	if _inventory[String(from_slot)]["amount"] > 1:
		# To Slot is empty
		if _inventory[String(to_slot)]["id"] == "0":
			_inventory[String(from_slot)]["amount"] -= 1
			inventory_update_item(to_slot, int(_inventory[String(from_slot)]["id"]), 1, _inventory[String(from_slot)]["seed_obj"])
		else:
			var temp_item : Dictionary = _inventory[String(to_slot)]
			var new_to_slot = inventory_get_empty_slot()
			
			if new_to_slot >= 0: 
				_inventory[String(from_slot)]["amount"] -= 1
				_inventory[String(to_slot)] = inventory_empty_slot()
				inventory_update_item(to_slot, int(_inventory[String(from_slot)]["id"]), 1, _inventory[String(from_slot)]["seed_obj"])
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
	return {"id": "0", "amount": 0, "seed_obj": null}

func get_index_plant(index: int) -> Plant:
	return _plant_goal_list[index]

func collect_plant(plant: Plant, photo: Image) -> void:
	if _plant_goal_status.has(plant.phenotype_hash):
		_plant_goal_status[plant.phenotype_hash] = true
		for p in _plant_goal_list:
			if p.phenotype_hash == plant.phenotype_hash:
				p.last_photo = photo
				return

func check_plant(plant: Plant) -> bool:
	if _plant_goal_status.has(plant.phenotype_hash):
		return _plant_goal_status[plant.phenotype_hash]
	else:
		return false
