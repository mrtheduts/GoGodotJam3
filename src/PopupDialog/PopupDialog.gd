#
# PopupDialog.gd
#

extends PanelContainer

class_name PopupWindow

const FLASH_DURATION := 0.25

# Signals
signal water_button_hold
signal photo_button_clicked
signal sell_button_clicked
signal closed
signal combine_button_clicked
signal discard_button_clicked

var drag_pos = null
var plant: Plant = null
var close_up_plant: CloseUpPlant = null

var is_watering := false
var watering_counter: float = 0

func _ready():
	Utils.conn_nodes(plant, "update_ui", self, "_on_Plant_update_ui")

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
		rect_global_position = get_viewport_transform().xform(get_global_mouse_position()) - drag_pos

func _on_CloseButton_pressed():
	$TweenClose.interpolate_property(
		self, "rect_scale",
		self.rect_scale, Vector2.ZERO,
		0.10, $TweenClose.TRANS_SINE, $TweenClose.EASE_OUT
	)
	$TweenClose.start()

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
	$Shuttle.play()
	$Flash.play()
	$Tween.start()

	var photo = $VBoxContainer/CenterContainer/ViewportContainer/Viewport.get_texture().get_data()
	photo.flip_y()
	emit_signal("photo_button_clicked", plant, photo)

func show_scene(node: CanvasItem) -> void:
	$VBoxContainer/CenterContainer/ViewportContainer/Viewport.add_child(node)
	show()
	rect_global_position = (get_viewport().size - rect_size) / 2
	$Tween.interpolate_property(
		self, "rect_scale",
		Vector2(1, 0),  Vector2(1, 1),
		0.25, $TweenClose.TRANS_SINE, $TweenClose.EASE_OUT
	)
	$Tween.start()


func _on_WaterButton_button_up():
	$Tween.interpolate_property(
		$Watering, "volume_db",
		$Watering.volume_db,  -80,
		1, $TweenClose.TRANS_SINE, $TweenClose.EASE_OUT
	)
	$Tween.start()
	is_watering = false
	emit_signal("water_button_hold", false)
	yield($Tween, "tween_all_completed")
	$Watering.stop()
	$Watering.volume_db = 0


func _on_WaterButton_button_down():
	$Watering.play()
	is_watering = true
	emit_signal("water_button_hold", true)


func _on_SellButton_pressed():
	if (plant != null):
		emit_signal("sell_button_clicked", plant)

	var view_size = get_viewport_rect().size
	self.rect_pivot_offset = Vector2(view_size.x, view_size.y)
	$TweenClose.interpolate_property(
		self, "rect_scale",
		self.rect_scale, Vector2(0, 0),
		0.25, $TweenClose.TRANS_SINE, $TweenClose.EASE_OUT
	)

	$TweenClose.interpolate_property(
		self, "rect_position",
		self.rect_position, Vector2.ZERO,
		0.25, $TweenClose.TRANS_SINE, $TweenClose.EASE_OUT
	)
	$TweenClose.start()

func _on_TweenClose_tween_all_completed():
	if (close_up_plant and is_instance_valid(close_up_plant)):
		close_up_plant.get_parent().remove_child(close_up_plant)
	emit_signal("closed", plant)
	self.queue_free()


func _on_DiscardButton_pressed():
	$Trash.play()
	if (plant != null):
		emit_signal("discard_button_clicked", plant)
	self.rect_pivot_offset.x = self.rect_pivot_offset.x/2
	$TweenClose.interpolate_property(
		self, "rect_scale",
		self.rect_scale, Vector2(0, 1),
		0.25, $TweenClose.TRANS_SINE, $TweenClose.EASE_OUT
	)
	$TweenClose.start()


func _on_Plant_update_ui(life_state: int):
	ui_for_life_stage(life_state)

func ui_for_life_stage(life_state: int):
	if (life_state == Constants.LIFE_STAGES.ADULT):
		$VBoxContainer/HBoxContainer/HBoxContainer/CombineButton.show()
		$VBoxContainer/HBoxContainer/HBoxContainer/PhotoButton.show()
	elif (life_state == Constants.LIFE_STAGES.DEAD):
		$VBoxContainer/HBoxContainer/HBoxContainer/SellButton.visible = false
		$VBoxContainer/HBoxContainer/HBoxContainer/CombineButton.visible = false
		$VBoxContainer/HBoxContainer/HBoxContainer/PhotoButton.visible = false
		$VBoxContainer/HBoxContainer/HBoxContainer/DiscardButton.show()

func _on_CombineButton_pressed():
	emit_signal("combine_button_clicked", plant)
