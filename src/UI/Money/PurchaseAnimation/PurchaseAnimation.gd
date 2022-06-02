extends MarginContainer

var speed = -60
var fade_speed = -1
	
func init(value: int):
	$HBoxContainer/Label.text = str(value)
	
func _process(delta):
	var move = Vector2()

	move.y = speed
	rect_position += move * delta
	modulate.a += fade_speed * delta
	
	if modulate.a < 0:
		queue_free()
