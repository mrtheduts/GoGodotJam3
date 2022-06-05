#
# UILayer.gd - Layer for Control nodes
#

extends CanvasLayer

# Signals

signal remove_plant
signal combine_crop

var POPUP_SCENE = preload("res://src/PopupDialog/PopupDialog.tscn")
var CLOSE_UP_SOIL_SCENE = preload("res://src/CloseUpPlot/CloseUpPlot.tscn")
var COMBINE_ANIMATION_SCENE = preload("res://src/UI/CombineAnimation/CombineAnimation.tscn")
var INDEX_SCENE = preload("res://src/PlantIndex/PlantIndex.tscn")

var SHOP_SCENE_PATH : String = "res://src/Shop/Shop.tscn"
var MAIN_SCENE_PATH : String = "res://src/Main/Main.tscn"

var active_scene : String = ""
var opened_plants := {}
var index_opened: bool = false

func _ready():
	if get_tree().get_current_scene().get_name() == "Shop":
		$WorldUI.visible = false
		
func _on_Garden_combine_plants(plants: Array, new_plant: Plant):
	for node in get_children():
		if node is PopupWindow:
			for plant in plants:
				if node.plant == plant:
					node.queue_free()
					if (opened_plants.has(plant)):
						# warning-ignore:return_value_discarded
						opened_plants.erase(plant)

	var combine_animation: CombineAnimation = COMBINE_ANIMATION_SCENE.instance()
	combine_animation.init(new_plant, get_viewport().size/2)
	add_child(combine_animation)


func _on_Garden_show_close_up_plant(plant):
	if (opened_plants.has(plant)):
		return

	var close_up_plant: CloseUpPlant = plant.close_up_plant
	var close_up_plot: CloseUpPlot = CLOSE_UP_SOIL_SCENE.instance()
	var camera_offset := close_up_plant.get_plant_center()
	
	var zoom_level = Constants.ZOOM_IN_LIFE_STAGES[plant.life_stage]
	close_up_plot.add_node_and_focus_camera(close_up_plant, camera_offset, zoom_level)
	Utils.conn_nodes(plant, "water_level_changed", close_up_plot, "change_water_level")

	var popup_window: PopupWindow = POPUP_SCENE.instance()
	Utils.conn_nodes(popup_window, "water_button_hold", close_up_plot, "set_WateringParticles_state")
	Utils.conn_nodes(popup_window, "photo_button_clicked", self, "_on_PopupWindow_photo_button_clicked")
	Utils.conn_nodes(popup_window, "sell_button_clicked", self, "_on_PopupWindow_sell_button_clicked")
	Utils.conn_nodes(popup_window, "discard_button_clicked", self, "_on_PopupWindow_discard_button_clicked")
	Utils.conn_nodes(popup_window, "closed", self, "_on_PopupWindow_closed")
	Utils.conn_nodes(close_up_plant, "update_ui", popup_window, "_on_Plant_update_ui")
	Utils.conn_nodes(popup_window, "combine_button_clicked", self, "_on_PopupWindow_combine_button_clicked")

	opened_plants[plant] = popup_window

	popup_window.plant = plant
	popup_window.close_up_plant = plant.close_up_plant
	add_child(popup_window)
	popup_window.show_scene(close_up_plot)

func _on_PopupWindow_photo_button_clicked(plant: Plant, photo: Image):
	PlayerState.collect_plant(plant, photo)

func _on_PopupWindow_sell_button_clicked(plant: Plant):
	PlayerState.add_money(plant.value)
	emit_signal("remove_plant", plant)

func _on_PopupWindow_closed(plant: Plant):
	if (opened_plants.has(plant)):
		# warning-ignore:return_value_discarded
		opened_plants.erase(plant)

func _on_PopupWindow_discard_button_clicked(plant: Plant):
	emit_signal("remove_plant", plant)
	
func _on_PopupWindow_combine_button_clicked(plant: Plant):
	emit_signal("combine_crop", plant)

func _on_Store_pressed():
	if get_tree().get_current_scene().get_name() == "Main":
		get_tree().change_scene(SHOP_SCENE_PATH)
	else:
		get_tree().change_scene(MAIN_SCENE_PATH)

func _on_OpenPlantIndex_open_index():
	if not index_opened:
		var index: PlantIndex = INDEX_SCENE.instance()
		Utils.conn_nodes(index, "index_closed", self, "_on_OpenPlantIndex_index_closed")
		add_child(index)
		index_opened = true

func _on_OpenPlantIndex_index_closed():
	index_opened = false
