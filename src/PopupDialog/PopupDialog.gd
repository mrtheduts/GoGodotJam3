#
# PopupDialog.gd
#

extends PanelContainer

class_name PopupWindow

var drag_pos = null



func _on_PopupDialog_resized():
#	$MarginContainer/ViewportContainer.rect_size = rect_size - Vector2(10,10)
#	$MarginContainer/ViewportContainer/Viewport.size = $MarginContainer/ViewportContainer.rect_size
	pass

func show_scene(node: CanvasItem) -> void:
	$VBoxContainer/ViewportContainer/Viewport.add_child(node)
	rect_global_position = (get_viewport().size - rect_size) / 2
	show()

func _on_HBoxContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("Pressed!")
			drag_pos = get_viewport_transform().xform(get_global_mouse_position()) - rect_global_position
		else:
			print("Not pressed!")
			drag_pos = null
		print(event)
	
	if event is InputEventMouseMotion and drag_pos != null:
		print(drag_pos)
		rect_global_position =get_viewport_transform().xform(get_global_mouse_position()) - drag_pos


func _on_CloseButton_pressed():
	self.queue_free()
