extends Node2D


var SEED_PACKET_SCENE = load("res://src/Shop/SeedPacket/SeedPacket.tscn")
var HOE_SCENE = load("res://src/Shop/Hoe/Hoe.tscn")
var BAG_SCENE = load("res://src/Shop/Bag/Bag.tscn")
var CHEST_SCENE = load("res://src/Shop/Chest/Chest.tscn")

const MAX_SEEDPACKET : int = 8
const TOOLS_ID : Array = ["Hoe", "Chest", "Bag"]
const SHELF_X : Array = [-390, -260, -130, 0, 130]
const SHELF_Y : Array = [-170, -30]

const HOE_POSITION : Vector2 = Vector2(-360, 180)
const CHEST_POSITION : Vector2 = Vector2(55, -40)
const BAG_POSITION : Vector2 = Vector2(-195, 160)
const DIALOG_POSITION : Vector2 = Vector2(-325, 239)

var shop_items : Array = []
var selected_item : Dictionary

func _on_SeedPacket_selection(id: int):
	selected_item = get_item_by_id(str(id))
	shopper_sell(selected_item["dialog"])
	Utils.conn_nodes($Dialog/BuyButton, "pressed", self, "make_purchase")

func _on_Tool_selection(id: String):
	selected_item = get_item_by_id(id)
	shopper_sell(selected_item["dialog"])
	Utils.conn_nodes($Dialog/BuyButton, "pressed", self, "make_purchase")

func _input(event):
	if event is InputEventKey and event.pressed:
			if event.scancode == KEY_ENTER:
				$Dialog.skip_dialog = true

func _ready():
	restock()
	
	if shop_items.size() > 0:
		display_items()
		
	shopper_dialog(Constants.SHOP_WELCOME_TEXT)

func shopper_dialog(text: String):
	$Dialog.talk(text)
	$Dialog.rect_position = DIALOG_POSITION
	
func shopper_sell(text: String):
	$Dialog.sell(text)
	$Dialog.rect_position = DIALOG_POSITION
	
func make_purchase():
	var value = selected_item["item"]._value
	print("Buying item by " + str(value))
	
	var new_balance = PlayerState._money - value
	if new_balance >= 0:
		PlayerState.set_money(new_balance)
		shopper_dialog(Constants.SHOP_THANKS_TEXT)
		selected_item["item"].queue_free()
		shop_items.erase(selected_item)
		selected_item = {}
	else:
		shopper_dialog(Constants.SHOP_WARN_TEXT)
		selected_item = {}

func display_items():
	for item in shop_items:
		if item["id"] in TOOLS_ID:
			if item ["id"] == "Hoe":
				item ["item"].position = HOE_POSITION
			elif item ["id"] == "Chest":
				item ["item"].position = CHEST_POSITION
			elif item ["id"] == "Bag":
				item ["item"].position = BAG_POSITION
			
			Utils.conn_nodes(item ["item"], "item_select", self, "_on_Tool_selection")
		else:
			var id = item["id"] - 1
			var position = Vector2(SHELF_X[id % 5], SHELF_Y[id / 5])
			item["item"].position = position
			Utils.conn_nodes(item["item"], "item_select", self, "_on_SeedPacket_selection")
		

func restock():
	shop_items = []
	restock_seeds()
	restock_tools()

func restock_tools():
	var new_hoe = HOE_SCENE.instance()
	var new_chest = CHEST_SCENE.instance()
	var new_bag = BAG_SCENE.instance()
	
	add_child(new_hoe)
	add_child(new_chest)
	add_child(new_bag)
	
	shop_items.append(
		{
			"id" : "Hoe",
			"item" : new_hoe,
			"dialog": Constants.SHOP_HOE_TEXT % str(new_hoe._value)
		}
	)
	shop_items.append(
		{
			"id" : "Bag",
			"item" : new_bag,
			"dialog": Constants.SHOP_BAG_TEXT % str(new_bag._value)
		}
	)
	shop_items.append(
		{
			"id" : "Chest",
			"item" : new_chest,
			"dialog": Constants.SHOP_CHEST_TEXT % str(new_chest._value)
		}
	)
	
func restock_seeds():	
	for i in range(1, MAX_SEEDPACKET+1):
		var seed_instance = get_random_seed(i)

		var seed_packet : Dictionary = {
			"id" : i,
			"item" : seed_instance,
			"dialog" : Constants.SHOP_SEED_TEXT % ["RANDOM", str(seed_instance._value)]
		}
		shop_items.append(seed_packet)

func get_random_seed(id: int):
	var new_seed_instance = SEED_PACKET_SCENE.instance()
	new_seed_instance.init(id, 10)
	add_child(new_seed_instance)
	return new_seed_instance
	
func get_item_by_id(id : String):
	for item in shop_items:
		if str(item["id"]) == id:
			return item

