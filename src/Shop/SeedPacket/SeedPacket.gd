extends Area2D


signal item_select

var SEED_SCENE = load("res://src/CloseUpPlant/Seed/Seed.tscn")

const ICON_PADDING : Vector2 = Vector2(0, 5)

var _id : int
var _plant : Plant
var _value : int

func init(id: int, plant: Plant):
	_id = id
	_value = ItemDatabase.get_item(String(Constants.SEED_ITEM_ID))["sell_price"]
	_plant = plant
	
	var new_seed = SEED_SCENE.instance()
	new_seed.init_seed(_plant)
	add_child(new_seed)
	
	new_seed.position = position + ICON_PADDING
	
func _input_event(_viewport, _event, _shape_idx):
	if _event is InputEventMouseButton:
		if _event.is_pressed():
			if _event.button_index == BUTTON_LEFT:
				emit_signal("item_select", _id)
	
