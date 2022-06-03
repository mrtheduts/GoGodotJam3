extends Area2D


signal item_select

var SEED_SCENE = load("res://src/CloseUpPlant/Seed/Seed.tscn")

const ICON_PADDING : Vector2 = Vector2(23, 10)

var _id : int
var _value : float
var _plant : Plant

func init(id, value):
	_id = id
	_value = value
	
	_plant = PlantFactory.gen_random_plant()
	
	var new_seed = SEED_SCENE.instance()
	new_seed.init_seed(_plant)
	add_child(new_seed)
	new_seed.position = position - Vector2(23, 10)
	
func _input_event(_viewport, _event, _shape_idx):
	if _event is InputEventMouseButton:
		if _event.is_pressed():
			if _event.button_index == BUTTON_LEFT:
				emit_signal("item_select", _id)
	
