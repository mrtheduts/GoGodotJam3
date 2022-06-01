#
# PopupDialog.gd
#

extends WindowDialog

class_name PopupWindow

func _ready():
	self.popup_centered_ratio()

func _on_PopupDialog_resized():
#	$MarginContainer/ViewportContainer.rect_size = rect_size - Vector2(10,10)
#	$MarginContainer/ViewportContainer/Viewport.size = $MarginContainer/ViewportContainer.rect_size
	pass

func show_scene(node: CanvasItem) -> void:
#	var viewport_texture: ViewportTexture = ViewportTexture.new()
#	viewport_texture.viewport_path("../ViewportContainer/Viewport")
	$MarginContainer/HSplitContainer/ViewportContainer/Viewport.add_child(node)
	popup_centered_ratio()
