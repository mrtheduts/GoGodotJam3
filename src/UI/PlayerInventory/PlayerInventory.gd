extends Control


const ICON_SIZE : Vector2 = Vector2(64, 64)
const EMPTY_ICON_PATH : String = "res://raw_assets/images/items_icons/empty_slot.png"

const NAME_TEXT_COLOR : String = "#04712f"
const TYPE_TEXT_COLOR : String = "#ab3639"
const SELL_TEXT_COLOR : String = "#8c7a30"
const DESC_TEXT_COLOR : String = "#274a99"

const OPTIONS_MENU_PADDING : Vector2 = Vector2(20, -110)

onready var is_dragging_item : bool = false
onready var is_dragging_seed : bool = false
onready var mouse_button_released : bool = true
onready var is_stack_enabled : bool = false

onready var initial_mouse_pos : Vector2 = Vector2()
onready var cursor_inside_itemlist : bool = false

var INVENTORY_SLOT_SCENE = preload("res://src/UI/PlayerInventory/InventorySlot/InventorySlot.tscn")
var CONFIRMATION_POPUP_SCENE = preload("res://src/UI/PlayerInventory/ItemMenu/PopupPanel_Confirmation.tscn")
var ITEM_MENU_POPUP_SCENE = preload("res://src/UI/PlayerInventory/ItemMenu/PopupPanel_ItemMenu.tscn")

var dragged_item_slot : int = -1
var active_item_slot : int = -1
var sell_item_slot : int = -1

var item_menu_popup : PopupPanel = null
var confirm_menu_popup : PopupPanel = null

func _ready():
	Utils.conn_nodes(PlayerState, "inventory_changed", self, "_on_PlayerState_inventory_changed")

	load_items()
	set_process(false)
	set_process_input(true)

	for i in range(1,6):
		if i >= 4:
			PlayerState.inventory_add_item(4, 4, PlantFactory.gen_random_plant())
		else:
			PlayerState.inventory_add_item(1)


func _process(_delta):
	if is_dragging_item:
		$Sprite_DraggedItem.global_position = get_viewport().get_mouse_position()
	elif is_dragging_seed:
		$Seed.global_position = get_viewport().get_mouse_position()

func _input(event):
	if event is InputEventMouseButton:
		if cursor_inside_itemlist:
			if event.is_action_pressed("mouse_leftbtn"):
					mouse_button_released = false
					initial_mouse_pos = get_viewport().get_mouse_position()

			if event.is_action("mouse_rightbtn"):
				if cursor_inside_itemlist:
					active_item_slot = get_item_at_position(get_local_mouse_position())
					if active_item_slot >= 0:
						show_item_options(active_item_slot)

			if event.doubleclick:
				active_item_slot = get_item_at_position(get_local_mouse_position())
				if active_item_slot >= 0:
					PlayerState.inventory_use_item(active_item_slot)

		if event.is_action_released("mouse_leftbtn"):
			move_merge_item()
			end_drag_item()

	if event is InputEventMouseMotion:
		if cursor_inside_itemlist:
			active_item_slot = get_item_at_position(get_viewport().get_mouse_position())
			if active_item_slot >= 0:
				if is_dragging_item or mouse_button_released or is_dragging_seed:
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
	for slot in $Slots.get_children():
		var slot_start = $Slots.rect_position + slot.rect_position
		var slot_end = slot_start + slot.rect_size
		if pos >= slot_start and pos <= slot_end:
			return slot.id
	return -1

func load_items():
	for slot in range(0, PlayerState._inventory_max_slots):
		update_slot(slot)

func update_slot(slot: int):
	if slot < 0:
		return

	var inventory_item : Dictionary = PlayerState._inventory[String(slot)]
	var item_meta_data = ItemDatabase.get_item(String(inventory_item["id"])).duplicate()
	var amount = int(inventory_item["amount"])

	item_meta_data["amount"] = amount
	if !item_meta_data["stackable"]:
		amount = " "

	for item_slot in $Slots.get_children():
		if item_slot.id == slot:
			item_slot.update_item(slot, item_meta_data, String(amount))
			return

	var new_slot = INVENTORY_SLOT_SCENE.instance()
	new_slot.update_item(slot, item_meta_data, amount)
	$Slots.add_child(new_slot)

func show_item_options(index: int):
	if is_dragging_item or is_dragging_seed or item_menu_popup != null:
		return

	sell_item_slot = index
	var item_data : Dictionary = ItemDatabase.get_item(String(PlayerState._inventory[String(index)]["id"]))

	if int(item_data["id"]) < 1:
		return

	var selected_slot : VBoxContainer = null

	for slot in $Slots.get_children():
		if slot.id == index:
			selected_slot = slot

	var str_item_info : String = ""

	str_item_info = "Name: [color="+ NAME_TEXT_COLOR +"] " + item_data["name"] + "[/color]\n"
	str_item_info = str_item_info + "Type: [color="+ TYPE_TEXT_COLOR +"] " + item_data["type"] + "[/color]\n"
	str_item_info = str_item_info + "Sell Price: [color="+ SELL_TEXT_COLOR +"] " + String(item_data["sell_price"]) + "[/color] gold\n"
	str_item_info = str_item_info + "\n[color="+ DESC_TEXT_COLOR +"]" + item_data["description"] + "[/color]"

	item_menu_popup = ITEM_MENU_POPUP_SCENE.instance()

	add_child(item_menu_popup)
	Utils.conn_nodes(item_menu_popup.get_node("MarginContainer/V/Button_SellItem"), "pressed", self, "_on_Item_sell_confirm")

	var popup_position = selected_slot.rect_global_position + OPTIONS_MENU_PADDING
	item_menu_popup.rect_position = popup_position
	item_menu_popup.get_node("MarginContainer/V/H_Desc/TextureRect_Icon").set_texture(ResourceLoader.load(item_data["icon"]))
	item_menu_popup.get_node("MarginContainer/V/H_Desc/MarginContainer_Text/RichTextLabel_ItemInfo").set_bbcode(str_item_info)

	active_item_slot = index

	yield(get_tree(), "idle_frame")
	item_menu_popup.popup()

func begin_drag_item(index: int):
	var inv_item = PlayerState.inventory_get_item(index)
	var item_id = inv_item["id"]

	if item_id == "0":
		return

	if is_dragging_item or is_dragging_seed:
		return

	if index < 0:
		return

	var item = ItemDatabase.get_item(item_id)
	set_process(true)

	if item_id == String(Constants.SEED_ITEM_ID):
		$Seed.init_seed(inv_item["seed_obj"])
		$Seed.scale = Vector2(3.5, 3.5)
		$Seed.show()
		is_dragging_seed = true
	else:
		$Sprite_DraggedItem.texture =  ResourceLoader.load(item["icon"])
		$Sprite_DraggedItem.show()
		is_dragging_item = true

	dragged_item_slot = index
	mouse_button_released = false
	if item_id == String(Constants.SEED_ITEM_ID):
		$Seed.global_translate(get_viewport().get_mouse_position())
	else:
		$Sprite_DraggedItem.global_translate(get_viewport().get_mouse_position())

func end_drag_item():
	set_process(false)
	dragged_item_slot = -1
	$Sprite_DraggedItem.hide()
	$Seed.hide()
	mouse_button_released = true
	is_dragging_item = false
	is_dragging_seed = false
	active_item_slot = -1

func move_merge_item():
	if dragged_item_slot < 0:
		return

	if active_item_slot < 0:
		return

	if active_item_slot != dragged_item_slot:
		if PlayerState.inventory_get_item(active_item_slot)["id"] == PlayerState.inventory_get_item(dragged_item_slot)["id"]:
			var itemData = ItemDatabase.get_item(PlayerState.inventory_get_item(active_item_slot)["id"])
			if int(itemData["stack_limit"]) >= 2:
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

func _on_PlayerState_inventory_changed(slot: int):
	update_slot(slot)

func _on_Item_sell_confirm():
	var screen_center = get_viewport_rect().size / 2
	var item_data : Dictionary = ItemDatabase.get_item(String(PlayerState._inventory[String(sell_item_slot)]["id"]))
	var str_confirm_text : String = ""

	str_confirm_text = "[center] You're about to sell your "
	str_confirm_text = str_confirm_text + "[color="+ NAME_TEXT_COLOR +"] " + item_data["name"] + "[/color].\n"
	str_confirm_text = str_confirm_text + "Do you want to proceed?[/center]"

	confirm_menu_popup = CONFIRMATION_POPUP_SCENE.instance()
	add_child(confirm_menu_popup)
	Utils.conn_nodes(confirm_menu_popup.get_node("MarginContainer/V/H/Button_Stack"), "pressed", self, "_on_Sell_stack")
	Utils.conn_nodes(confirm_menu_popup.get_node("MarginContainer/V/H/Button_Confirm"), "pressed", self, "_on_Sell_confirm")
	Utils.conn_nodes(confirm_menu_popup.get_node("MarginContainer/V/H/Button_Cancel"), "pressed", self, "_on_Sell_cancel")

	confirm_menu_popup.get_node("MarginContainer/V/MarginContainer_Text/RichTextLabel_Text").set_bbcode(str_confirm_text)

	var popup_size = confirm_menu_popup.rect_size / 2
	confirm_menu_popup.set_position(screen_center - popup_size)

	yield(get_tree(), "idle_frame")
	confirm_menu_popup.popup()

func _on_Sell_stack():
	PlayerState.inventory_sell_item(sell_item_slot, PlayerState._inventory[String(sell_item_slot)]["amount"])
	update_slot(sell_item_slot)
	sell_item_slot = -1

	confirm_menu_popup.queue_free()
	confirm_menu_popup = null

	item_menu_popup.queue_free()
	item_menu_popup = null

func _on_Sell_confirm():
	PlayerState.inventory_sell_item(sell_item_slot, 1)
	update_slot(sell_item_slot)
	sell_item_slot = -1

	confirm_menu_popup.queue_free()
	confirm_menu_popup = null

	item_menu_popup.queue_free()
	item_menu_popup = null
	
func _on_Sell_cancel():
	sell_item_slot = -1

	confirm_menu_popup.queue_free()
	confirm_menu_popup = null

	item_menu_popup.queue_free()
	item_menu_popup = null

func _on_Slots_mouse_exited():
	cursor_inside_itemlist = false

func _on_Slots_mouse_entered():
	cursor_inside_itemlist = true
