extends Control


const ICON_SIZE : Vector2 = Vector2(64, 64)
const EMPTY_ICON_PATH : String = "res://raw_assets/images/items_icons/empty_slot.png"

onready var is_dragging_item : bool = false
onready var mouse_button_released : bool = true
onready var is_stack_enabled : bool = false

onready var initial_mouse_pos : Vector2 = Vector2()
onready var cursor_inside_itemlist : bool = false

var INVENTORY_SLOT_SCENE = load("res://src/PlayerInventory/InventorySlot/InventorySlot.tscn")

var dragged_item_slot : int = -1
var active_item_slot : int = -1
var drop_item_slot : int = -1

func _ready():	
	Utils.conn_nodes($ItemContainer, "mouse_entered", self, "_on_ItemList_mouse_entered")
	Utils.conn_nodes($ItemContainer, "mouse_exited", self, "_on_ItemList_mouse_exited")

	load_items()

	set_process(false)
	set_process_input(true)
	
	for i in range(1,20):
		var slot = 0
		if i >= 4:
			slot = PlayerState.inventory_add_item(4)
		else:
			slot = PlayerState.inventory_add_item(i)
		update_slot(slot)

#warning-ignore:unused_argument
func _process(delta):
	if is_dragging_item:
		$ItemContainer/Sprite_DraggedItem.global_position = get_viewport().get_mouse_position()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("mouse_leftbtn"):
			mouse_button_released = false
			initial_mouse_pos = get_viewport().get_mouse_position()
		if event.is_action_released("mouse_leftbtn"):
			move_merge_item()
			end_drag_item()
		if event.is_action("mouse_rightbtn"):
			if cursor_inside_itemlist:
				active_item_slot = get_item_at_position($ItemContainer.get_local_mouse_position())
				if active_item_slot >= 0:
					show_item_options(active_item_slot)
			
	if event is InputEventMouseMotion:
		if cursor_inside_itemlist:
			active_item_slot = get_item_at_position($ItemContainer.get_local_mouse_position())
			if active_item_slot >= 0:
				if is_dragging_item or mouse_button_released:
					return
				if initial_mouse_pos.distance_to(get_viewport().get_mouse_position()) > 0.0:
					begin_drag_item(active_item_slot)
		else:
			active_item_slot = -1
	
	if event is InputEventKey:
		if event.is_action_pressed("shift"):
			is_stack_enabled = true
		elif event.is_action_released("shift"):
			is_stack_enabled = false

func get_item_at_position(pos: Vector2):
	for slot in $ItemContainer/Slots.get_children():
		var slot_start = slot.rect_position
		var slot_end = slot_start + slot.rect_size
		if pos >= slot_start and pos <= slot_end:
			return slot.id
	return -1
		
func load_items():
	for slot in range(0, PlayerState._inventory_max_slots):
		update_slot(slot)

func update_slot(slot: int):
	if (slot < 0):
		return
	var inventory_item : Dictionary = PlayerState._inventory[str(slot)]
	var item_meta_data = ItemDatabase.get_item(str(inventory_item["id"])).duplicate()
	var amount = int(inventory_item["amount"])
	
	item_meta_data["amount"] = amount
	if (!item_meta_data["stackable"]):
		amount = " "
		
	for item_slot in $ItemContainer/Slots.get_children():
		if item_slot.id == slot:
			item_slot.update_item(slot, item_meta_data, str(amount))
			return
		
	var new_slot = INVENTORY_SLOT_SCENE.instance()
	new_slot.update_item(slot, item_meta_data, amount)
	$ItemContainer/Slots.add_child(new_slot)
	
func show_item_options(index: int):
	
	if (is_dragging_item):
		return

	drop_item_slot = index
	var item_data : Dictionary = ItemDatabase.get_item(String(PlayerState._inventory[str(index)]["id"]))
	
	if int(item_data["id"]) < 1: 
		return
		
	var str_item_info : String = ""
	
	$PopupPanel_ItemMenu.set_position(get_viewport().get_mouse_position())
	$PopupPanel_ItemMenu/V/H_Desc/TextureRect_Icon.set_texture(ResourceLoader.load(item_data["icon"]))

	str_item_info = "Name: [color=#00aedb] " + item_data["name"] + "[/color]\n"
	str_item_info = str_item_info + "Type: [color=#f37735] " + item_data["type"] + "[/color]\n"
	str_item_info = str_item_info + "Sell Price: [color=#ffc425] " + String(item_data["sell_price"]) + "[/color] gold\n"
	str_item_info = str_item_info + "\n[color=#b3cde0]" + item_data["description"] + "[/color]"
	
	$PopupPanel_ItemMenu/V/H_Desc/RichTextLabel_ItemInfo.set_bbcode(str_item_info)
	#$Panel/WindowDialog_ItemMenu/Button_DropItem.set_text("(" + String(item_data["amount"]) + ") Drop" )
	active_item_slot = index
	$PopupPanel_ItemMenu.popup()

func begin_drag_item(index:int) -> void:
	var item_id = PlayerState.inventory_get_item(index)["id"]
	
	if item_id == "0":
		return
		
	if (is_dragging_item):
		return
		
	if (index < 0):
		return
	
	var item = ItemDatabase.get_item(item_id)
	set_process(true)
	$ItemContainer/Sprite_DraggedItem.texture =  ResourceLoader.load(item["icon"])
	$ItemContainer/Sprite_DraggedItem.show()

	dragged_item_slot = index
	is_dragging_item = true
	mouse_button_released = false
	$ItemContainer/Sprite_DraggedItem.global_translate(get_viewport().get_mouse_position())

func end_drag_item() -> void:
	set_process(false)
	dragged_item_slot = -1
	$ItemContainer/Sprite_DraggedItem.hide()
	mouse_button_released = true
	is_dragging_item = false
	active_item_slot = -1

func move_merge_item() -> void:
	if (dragged_item_slot < 0):
		return
		
	if (active_item_slot < 0):
		return

	if (active_item_slot != dragged_item_slot):
		if (PlayerState.inventory_get_item(active_item_slot)["id"] == PlayerState.inventory_get_item(dragged_item_slot)["id"]):
			var itemData = ItemDatabase.get_item(PlayerState.inventory_get_item(active_item_slot)["id"])
			if (int(itemData["stack_limit"]) >= 2):
				if is_stack_enabled:
					PlayerState.inventory_merge_stack(dragged_item_slot, active_item_slot)
				else:
					PlayerState.inventory_merge_item(dragged_item_slot, active_item_slot)
				update_slot(dragged_item_slot)
				update_slot(active_item_slot)
				return
			else:
				update_slot(dragged_item_slot)
				return
		else:
			var new_slot = -1
			if is_stack_enabled:
				PlayerState.inventory_move_stack(dragged_item_slot, active_item_slot)
			else:
				new_slot = PlayerState.inventory_move_item(dragged_item_slot, active_item_slot)
				
			if new_slot > 0:
				update_slot(new_slot)
			update_slot(dragged_item_slot)
			update_slot(active_item_slot)

func _on_ItemList_mouse_entered():
	cursor_inside_itemlist = true;

func _on_ItemList_mouse_exited():
	cursor_inside_itemlist = false;
