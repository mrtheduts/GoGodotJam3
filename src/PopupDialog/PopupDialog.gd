extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	popup_centered_ratio()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PopupDialog_resized():
#	$MarginContainer/ViewportContainer.rect_size = rect_size - Vector2(10,10)
	print($MarginContainer/ViewportContainer.rect_size)
#	$MarginContainer/ViewportContainer/Viewport.size = $MarginContainer/ViewportContainer.rect_size
