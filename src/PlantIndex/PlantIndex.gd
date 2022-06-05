extends PanelContainer
class_name PlantIndex

# Signal
signal index_closed

# State
var _page: int = 2

# Components
onready var _back_button: TextureButton = $VBoxContainer/HBoxContainerBot/BackButton
onready var _next_button: TextureButton = $VBoxContainer/HBoxContainerBot/NextButton
onready var _page_1: IndexEntry = $VBoxContainer/HBoxContainerMid/Page1
onready var _page_2: IndexEntry = $VBoxContainer/HBoxContainerMid/Page2

func _ready():
	update_entries()
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
	update_entries()

func update_entries():
	var entry = PlayerState.get_index_plant(_page - 2)
	_page_1.init_plant(entry)
	entry = PlayerState.get_index_plant(_page - 1)
	_page_2.init_plant(entry)

func update_buttons():
	var first_page = bool(_page - 2)
	_back_button.visible = first_page
	_back_button.disabled = !first_page
	
	var last_page = bool(Constants.INDEX_ENTRIES - _page)
	_next_button.visible = last_page
	_next_button.disabled = !last_page
