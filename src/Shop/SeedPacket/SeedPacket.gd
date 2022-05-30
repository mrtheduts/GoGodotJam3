extends Area2D


signal buy_attempt

var _id : int
var _value : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(id, value):
	_id = id
	_value = value
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				buy()

func buy() -> void:
	print("Buying attempt")
	emit_signal("buy_attempt", _id)
	
