extends Area2D


signal item_select

var _value : int = 50
var _id : String = "Bag"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input_event(_viewport, _event, _shape_idx):
	if _event is InputEventMouseButton:
		if _event.is_pressed():
			if _event.button_index == BUTTON_LEFT:
				emit_signal("item_select", _id)
	
