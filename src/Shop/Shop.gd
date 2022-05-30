extends Node2D


# Declare member variables here. Examples:
var seed_packet_scene = load("res://src/Shop/SeedPacket/SeedPacket.tscn")
var hoe_scene = load("res://src/Shop/Hoe/Hoe.tscn")
var bag_scene = load("res://src/Shop/Bag/Bag.tscn")
var chest_scene = load("res://src/Shop/Chest/Chest.tscn")

signal buy_attempt

var MAX_SEEDPACKET : int = 8
var SHELF_X : Array = [-390, -260, -130, 0, 130]
var SHELF_Y : Array = [-170, -30]

var HOE_POSITION : Vector2 = Vector2(-360, 180)
var CHEST_POSITION : Vector2 = Vector2(55, -40)
var BAG_POSITION : Vector2 = Vector2(-195, 160)

var tools : Array = []
var seed_slots : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	restock()
	
	if len(seed_slots) != 0:
		display_seeds()
		
	if len(tools) != 0:
		display_tools()

func _on_SeedPacket_buy_attempt(id: int):
	var seed_packet = get_seed_by_id(id)
	var value = seed_packet["item"]._value
	if make_purchase(value):
		seed_packet["item"].queue_free()
		seed_slots.erase(seed_packet)

func _on_Tool_buy_attempt(id: String):
	var tool_item = get_tool_by_id(id)
	var value = tool_item["item"]._value
	if make_purchase(value):
		tool_item["item"].queue_free()
		tools.erase(tool_item)

func make_purchase(value: int):
	print("Buying item by " + str(value))
	# Check for user money
	return true
	
func display_seeds():
	for seed_packet in seed_slots:
		var id = seed_packet["id"] - 1
		var position = Vector2(SHELF_X[id % 5], SHELF_Y[id / 5])
		seed_packet["item"].position = position
		Utils.conn_nodes(seed_packet["item"], "buy_attempt", self, "_on_SeedPacket_buy_attempt")

func display_tools():
	for item_tool in tools:
		if item_tool["id"] == "Hoe":
			item_tool["item"].position = HOE_POSITION
		elif item_tool["id"] == "Chest":
			item_tool["item"].position = CHEST_POSITION
		elif item_tool["id"] == "Bag":
			item_tool["item"].position = BAG_POSITION
		else:
			print("Error: The is no item with this name")
		
		Utils.conn_nodes(item_tool["item"], "buy_attempt", self, "_on_Tool_buy_attempt")

func restock():
	restock_seeds()
	restock_tools()

func restock_tools():
	tools = []
	
	var new_hoe = hoe_scene.instance()
	var new_chest = chest_scene.instance()
	var new_bag = bag_scene.instance()
	
	add_child(new_hoe)
	add_child(new_chest)
	add_child(new_bag)
	
	tools.append(
		{
			"id" : "Hoe",
			"item" : new_hoe
		}
	)
	tools.append(
		{
			"id" : "Bag",
			"item" : new_bag
		}
	)
	tools.append(
		{
			"id" : "Chest",
			"item" : new_chest
		}
	)
	
func restock_seeds():
	seed_slots = []
	
	for i in range(1, MAX_SEEDPACKET+1):
		var seed_packet : Dictionary = {
			"id" : i,
			"item" : get_random_seed(i)
		}
		seed_slots.append(seed_packet)

func get_random_seed(id: int):
	var new_seed_instance = seed_packet_scene.instance()
	new_seed_instance.init(id, 10)
	add_child(new_seed_instance)
	return new_seed_instance

func get_tool_by_id(id : String):
	for item in tools:
		if item["id"] == id:
			return item
			
func get_seed_by_id(id : int):
	for packet in seed_slots:
		if packet["id"] == id:
			return packet
	
