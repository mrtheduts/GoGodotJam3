extends Area2D


signal item_select

var _id : int
var _value : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(id, value):
	_id = id
	_value = value
	
func _input_event(_viewport, _event, _shape_idx):
	if _event is InputEventMouseButton:
		if _event.is_pressed():
			if _event.button_index == BUTTON_LEFT:
				emit_signal("item_select", _id)
	
