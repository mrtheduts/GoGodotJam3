#
# PopupDialog.gd
#

extends PanelContainer

class_name PopupWindow

# Signals
signal water_button_clicked
signal photo_button_clicked

var drag_pos = null
var plant: Plant = null

func _on_PopupDialog_resized():
#	$MarginContainer/ViewportContainer.rect_size = rect_size - Vector2(10,10)
#	$MarginContainer/ViewportContainer/Viewport.size = $MarginContainer/ViewportContainer.rect_size
	pass

func show_scene(node: CanvasItem) -> void:
	$VBoxContainer/CenterContainer/ViewportContainer/Viewport.add_child(node)
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


func _on_WaterButton_pressed():
	plant.water()


func _on_PhotoButton_pressed():
	$Tween.interpolate_property(
		$VBoxContainer/CenterContainer/ViewportContainer/ColorRect,
		"modulate",
		Color(1,1,1,0),
		Color(1,1,1,0.95),
		0.25,
		$Tween.TRANS_EXPO,
		# Easing out means we start fast and slow down as we reach the target value.
		$Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		$VBoxContainer/CenterContainer/ViewportContainer/ColorRect,
		"modulate",
		Color(1,1,1,0.95),
		Color(1,1,1,0),
		0.25,
		$Tween.TRANS_EXPO,
		# Easing out means we start fast and slow down as we reach the target value.
		$Tween.EASE_OUT,
		0.25
	)
	$Tween.start()
	var photo = $VBoxContainer/CenterContainer/ViewportContainer/Viewport.get_texture().get_data()
	photo.flip_y()
	print(photo)
	emit_signal("photo_button_clicked", plant, photo)
