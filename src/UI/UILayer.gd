#
# UILayer.gd - Layer for Control nodes
#

extends CanvasLayer

var POPUP_SCENE = preload("res://src/PopupDialog/PopupDialog.tscn")
var CLOSE_UP_SOIL_SCENE = preload("res://src/CloseUpPlot/CloseUpPlot.tscn")

func _on_Garden_show_close_up_plant(close_up_plant: CloseUpPlant):
	var close_up_plot: CloseUpPlot = CLOSE_UP_SOIL_SCENE.instance()
	var camera_offset := close_up_plant.get_plant_center()
	close_up_plot.add_node_and_focus_camera(close_up_plant, camera_offset, 3.5)
	
	var popup_window: PopupWindow = POPUP_SCENE.instance()
	add_child(popup_window)
	popup_window.show_scene(close_up_plot)
