#
# PopupDialog.gd
#

extends WindowDialog

func _on_PopupDialog_resized():
#	$MarginContainer/ViewportContainer.rect_size = rect_size - Vector2(10,10)
#	$MarginContainer/ViewportContainer/Viewport.size = $MarginContainer/ViewportContainer.rect_size
	pass

func show_scene(node: CanvasItem) -> void:
	$MarginContainer/ViewportContainer/Viewport.add_child(node)
	popup_centered_ratio()
