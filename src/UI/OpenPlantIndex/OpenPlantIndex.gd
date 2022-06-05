extends MarginContainer

signal open_index

func _on_IndexButton_pressed():
	emit_signal("open_index")
