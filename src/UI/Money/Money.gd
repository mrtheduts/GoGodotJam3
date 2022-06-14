extends MarginContainer

const PURCHASE_POSITION_REL : Vector2 = Vector2(0, -1000)
const PURCHASE_SCALE : Vector2 = Vector2(0.1, 0.1)

var PURCHASE_ANIMATION_SCENE = load("res://src/UI/Money/PurchaseAnimation/PurchaseAnimation.tscn")

onready var current_money : int = PlayerState._money

func _ready():
	Utils.conn_nodes(PlayerState, "money_changed", self, "_on_PlayerState_money_changed")
	$HBoxContainer/Label.text = String(PlayerState._money)

func _on_PlayerState_money_changed(value: int):
	if is_inside_tree():
		$AudioStreamPlayer.play()
		var diff = value - current_money
		show_purchase_animation(diff)
	$HBoxContainer/Label.text = String(value)
	current_money = value

func show_purchase_animation(value: int):
	var purchase_animation = PURCHASE_ANIMATION_SCENE.instance()
	purchase_animation.rect_position += PURCHASE_POSITION_REL
	purchase_animation.init(value)
	add_child(purchase_animation)
