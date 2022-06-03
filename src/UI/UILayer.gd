#
# UILayer.gd - Layer for Control nodes
#

extends CanvasLayer

# Signals
signal photo_took

var POPUP_SCENE = preload("res://src/PopupDialog/PopupDialog.tscn")
var CLOSE_UP_SOIL_SCENE = preload("res://src/CloseUpPlot/CloseUpPlot.tscn")

func _on_Garden_show_close_up_plant(plant: Plant):
	var close_up_plant: CloseUpPlant = plant.close_up_plant
	var close_up_plot: CloseUpPlot = CLOSE_UP_SOIL_SCENE.instance()
	var camera_offset := close_up_plant.get_plant_center()
	close_up_plot.add_node_and_focus_camera(close_up_plant, camera_offset, 3.5)
	
	var popup_window: PopupWindow = POPUP_SCENE.instance()
	
	Utils.conn_nodes(popup_window, "water_button_hold", close_up_plot, "set_WateringParticles_state")
	Utils.conn_nodes(popup_window, "photo_button_clicked", self, "_on_PopupWindow_photo_button_clicked")
	Utils.conn_nodes(popup_window, "sell_button_clicked", self, "_on_PopupWindow_sell_button_clicked")
	
	popup_window.plant = plant
	add_child(popup_window)
	popup_window.show_scene(close_up_plot)

func _on_PopupWindow_photo_button_clicked(plant: Plant, photo: Image):
	emit_signal("photo_took", plant, photo)

func _on_PopupWindow_sell_button_clicked(value: int):
	PlayerState.add_money(value)
