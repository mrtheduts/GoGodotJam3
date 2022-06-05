extends Node


var SEED_PACKET_SCENE = load("res://src/Shop/SeedPacket/SeedPacket.tscn")
var HOE_SCENE = load("res://src/Shop/Hoe/Hoe.tscn")
var BAG_SCENE = load("res://src/Shop/Bag/Bag.tscn")
var CHEST_SCENE = load("res://src/Shop/Chest/Chest.tscn")

const MAX_SEEDPACKET : int = 6
const TOOLS_ID : Array = ["Hoe", "Chest", "Bag"]
const SHELF_X : Array = [-270, -140, -10]
const SHELF_Y : Array = [-160, -20]

const HOE_POSITION : Vector2 = Vector2(-330, 180)
const CHEST_POSITION : Vector2 = Vector2(55, -40)
const BAG_POSITION : Vector2 = Vector2(-195, 160)
const DIALOG_POSITION : Vector2 = Vector2(-325, 239)

var ITEM_ID_MAPPING : Dictionary = {
	"Hoe" : Constants.HOE_ITEM_ID
}

var _shop_level : int = 0
var selected_item : Dictionary
var displayed_tools_id : Array = [1]

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
	if PlayerState._shop_can_restock:
		PlayerState._shop_can_restock = false
		restock()
	else:
		load_stock()
		
	if PlayerState._shop_items.size() > 0:
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
	var new_balance = PlayerState._money - value
		
	if new_balance >= 0 and PlayerState.inventory_get_empty_slot() >= 0:
		PlayerState.set_money(new_balance)

		var shop_id = selected_item["id"]
		
		if shop_id in TOOLS_ID:
			PlayerState.inventory_add_item(ITEM_ID_MAPPING[shop_id])
		else:
			PlayerState.inventory_add_item(Constants.SEED_ITEM_ID, 4, selected_item["item"]._plant)
		
		shopper_dialog(Constants.SHOP_THANKS_TEXT)
		
		selected_item["item"].queue_free()
		PlayerState._shop_items.erase(selected_item)
		selected_item = {}
	else:
		var reason: String = ""
		if new_balance < 0:
			reason = "money"
		else:
			reason = "inventory space"
		shopper_dialog(Constants.SHOP_WARN_TEXT % reason)
		selected_item = {}

func display_items():
	for item in PlayerState._shop_items:
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
			var position = Vector2(SHELF_X[id % SHELF_X.size()], SHELF_Y[id / SHELF_X.size()])
			item["item"].position = position
			Utils.conn_nodes(item["item"], "item_select", self, "_on_SeedPacket_selection")

func load_stock():
	for item in PlayerState._shop_items:
		if item["id"] in TOOLS_ID:
			if item ["id"] == "Hoe":
				var new_hoe = HOE_SCENE.instance()
				add_child(new_hoe)
				item ["item"] = new_hoe
		else:
			var seed_instance = SEED_PACKET_SCENE.instance()
		
			seed_instance.init(item["id"], item["plant"])
			add_child(seed_instance)
			item["item"] = seed_instance
			
func restock():
	PlayerState._shop_items = []
	restock_seeds()
	restock_tools()

func restock_tools():
	var new_hoe = HOE_SCENE.instance()
	add_child(new_hoe)
	PlayerState._shop_items.append(
		{
			"id" : "Hoe",
			"item" : new_hoe,
			"plant": null,
			"dialog": Constants.SHOP_HOE_TEXT % str(new_hoe._value)
		}
	)
	
func restock_seeds():	
	for i in range(1, MAX_SEEDPACKET+1):
		var seed_instance = SEED_PACKET_SCENE.instance()
		
		seed_instance.init(i, PlantFactory.gen_random_plant())
		add_child(seed_instance)

		var seed_packet : Dictionary = {
			"id" : i,
			"item" : seed_instance,
			"plant" : seed_instance._plant,
			"dialog" : Constants.SHOP_SEED_TEXT % str(seed_instance._value)
		}
		PlayerState._shop_items.append(seed_packet)
	
func get_item_by_id(id : String):
	for item in PlayerState._shop_items:
		if str(item["id"]) == id:
			return item

