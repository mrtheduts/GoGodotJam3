#
# UILayer.gd - Layer for Control nodes
#

extends CanvasLayer

# Signals
signal photo_took

var POPUP_SCENE = preload("res://src/PopupDialog/PopupDialog.tscn")
var CLOSE_UP_SOIL_SCENE = preload("res://src/CloseUpPlot/CloseUpPlot.tscn")

var opened_plants := {}

func _on_Garden_show_close_up_plant(plant: Plant):
	if (opened_plants.has(plant)):
		return
	
	var close_up_plant: CloseUpPlant = plant.close_up_plant
	var close_up_plot: CloseUpPlot = CLOSE_UP_SOIL_SCENE.instance()
	var camera_offset := close_up_plant.get_plant_center()
	
	close_up_plot.add_node_and_focus_camera(close_up_plant, camera_offset, 3.5)
	Utils.conn_nodes(plant, "water_level_changed", close_up_plot, "change_water_level")
	
	var popup_window: PopupWindow = POPUP_SCENE.instance()
	Utils.conn_nodes(popup_window, "water_button_hold", close_up_plot, "set_WateringParticles_state")
	Utils.conn_nodes(popup_window, "photo_button_clicked", self, "_on_PopupWindow_photo_button_clicked")
	Utils.conn_nodes(popup_window, "sell_button_clicked", self, "_on_PopupWindow_sell_button_clicked")
	Utils.conn_nodes(popup_window, "closed", self, "_on_PopupWindow_closed")
	
	opened_plants[plant] = popup_window
	
	popup_window.plant = plant
	popup_window.close_up_plant = plant.close_up_plant
	add_child(popup_window)
	popup_window.show_scene(close_up_plot)

func _on_PopupWindow_photo_button_clicked(plant: Plant, photo: Image):
	emit_signal("photo_took", plant, photo)

func _on_PopupWindow_sell_button_clicked(value: int):
	PlayerState.add_money(value)

func _on_PopupWindow_closed(plant: Plant):
	if (opened_plants.has(plant)):
		opened_plants.erase(plant)
