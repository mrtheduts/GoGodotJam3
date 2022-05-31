extends MarginContainer

func _ready():
	Utils.conn_nodes(PlayerState, "money_changed", self, "_on_PlayerState_money_changed")
	$HBoxContainer/Label.text = String(PlayerState._money)

func _on_PlayerState_money_changed(value: int):
	$HBoxContainer/Label.text = String(value)
