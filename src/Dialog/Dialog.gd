extends PopupDialog


const SKIP_SPEED : int = 150
const MAX_SPEED : int = 25
const BREAK_SPEED : int = 2
const TEXT_MARGIN : int = 30

var speed : int = MAX_SPEED
var visible_chars : float = 0.0
var skip_dialog : float = false
var buy_option : float = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_text_size()
	

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				skip_dialog = true
		elif event is InputEventKey and event.pressed:
			if event.scancode == KEY_ENTER:
				print("HEY")
				skip_dialog = true
	
func talk(text: String):
	skip_dialog = false
	buy_option = false
	
	$BuyButton.visible = false
	$DialogText.bbcode_text = text
	
	$DialogText.visible_characters = 0
	visible_chars = 0
	
	popup()
	set_process(true)

func sell(text: String):
	skip_dialog = false
	buy_option = true
	
	$BuyButton.visible = false
	$DialogText.bbcode_text = text
	
	$DialogText.visible_characters = 0
	visible_chars = 0
	
	popup()
	set_process(true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible_chars > 0:
		if skip_dialog:
			speed = SKIP_SPEED
		elif $DialogText.text[round(visible_chars) - 1] in ["!", ".", "?"]:
			speed = BREAK_SPEED
		else:
			speed = MAX_SPEED

	visible_chars += speed * delta
	$DialogText.visible_characters = round(visible_chars)
	
	if $DialogText.visible_characters >= len($DialogText.text):
		if (buy_option):
			$BuyButton.visible = true
		set_process(false)

func set_text_size():
	$DialogText.rect_size = rect_size - Vector2(TEXT_MARGIN * 2, rect_size.y/2)
