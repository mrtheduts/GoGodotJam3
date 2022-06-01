#
# PopupDialog.gd
#

extends PanelContainer

class_name PopupWindow

const FLASH_DURATION := 0.25

# Signals
signal water_button_hold
signal photo_button_clicked

var drag_pos = null
var plant: Plant = null

var is_watering := false
var watering_counter: float = 0

func _process(delta):
	if (is_watering and plant != null):
		watering_counter += delta
		if (watering_counter >= Constants.MIN_WATERED_AMOUNT):
			plant.water()
			watering_counter = 0

func _on_HBoxContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			drag_pos = get_viewport_transform().xform(get_global_mouse_position()) - rect_global_position
		else:
			drag_pos = null
	
	if event is InputEventMouseMotion and drag_pos != null:
		rect_global_position =get_viewport_transform().xform(get_global_mouse_position()) - drag_pos

func _on_CloseButton_pressed():
	self.queue_free()

func _on_PhotoButton_pressed():
	$Tween.interpolate_property(
		$VBoxContainer/CenterContainer/ViewportContainer/ColorRect, "modulate",
		Color(1,1,1,0), Color(1,1,1,0.95), 
		FLASH_DURATION, $Tween.TRANS_EXPO, $Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		$VBoxContainer/CenterContainer/ViewportContainer/ColorRect, "modulate",
		Color(1,1,1,0.95), Color(1,1,1,0.0), 
		FLASH_DURATION, $Tween.TRANS_QUAD, $Tween.EASE_OUT, FLASH_DURATION
	)
	$Tween.start()
	
	var photo = $VBoxContainer/CenterContainer/ViewportContainer/Viewport.get_texture().get_data()
	photo.flip_y()
	emit_signal("photo_button_clicked", plant, photo)

func show_scene(node: CanvasItem) -> void:
	$VBoxContainer/CenterContainer/ViewportContainer/Viewport.add_child(node)
	rect_global_position = (get_viewport().size - rect_size) / 2
	show()

func _on_WaterButton_button_up():
	is_watering = false
	emit_signal("water_button_hold", false)


func _on_WaterButton_button_down():
	is_watering = true
	emit_signal("water_button_hold", true)
