extends PanelContainer
class_name PlantIndex

# Signal
signal index_closed

# State
var _page: int = 2

func _ready():
	update_buttons()

func _on_CloseButton_pressed():
	self.rect_pivot_offset = Vector2(0, 0)
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
	emit_signal("index_closed")
	self.queue_free()

func _on_BackButton_pressed():
	change_page(-2)
	update_buttons()

func _on_NextButton_pressed():
	change_page(2)
	update_buttons()

func change_page(increment: int):
	_page += increment

func update_buttons():
	var first_page = bool(_page - 2)
	$VBoxContainer/HBoxContainerBot/BackButton.visible = first_page
	$VBoxContainer/HBoxContainerBot/BackButton.disabled = !first_page
	
	var last_page = bool(Constants.INDEX_PAGES - _page)
	$VBoxContainer/HBoxContainerBot/NextButton.visible = last_page
	$VBoxContainer/HBoxContainerBot/NextButton.disabled = !last_page
