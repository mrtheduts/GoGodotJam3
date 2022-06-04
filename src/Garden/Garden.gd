extends TileMap

# Signals
signal show_close_up_plant

# Constants
const PLANT_TILE_ID : int = 8
const GRASS_TILE_ID : int = 9
const SELECTION_TILE_ID : int = 0
const SELECTION_TILE_HOVER_ID : int = 1

const MIN_X : int = -4
const MIN_Y : int = -3
const MAX_X : int = 7
const MAX_Y : int = 6

const OUTBOUND_TILE : Vector2 = Vector2(-1000, -1000)

var crop_tiles : Dictionary = {}

var OVERVIEW_PLANT_SCENE = preload('res://src/OverviewPlant/OverviewPlant.tscn')

onready var planting_mode : bool = false
onready var increase_garden_mode : bool = false
onready var selected_tile : Vector2 = OUTBOUND_TILE

func _ready():
	Utils.conn_nodes(PlayerState, "planting_mode", self, "_on_PlayerState_planting_mode")
	Utils.conn_nodes(PlayerState, "edit_garden_mode", self, "_on_PlayerState_edit_garden_mode")
	Utils.conn_nodes(WorldManager, "time_changed", self, "_on_WorldManager_time_changed")
	
	if (crop_tiles.empty()):
		init_garden()
		
	draw_grass_area()
	draw_garden_tiles()
	self.modulate = WorldManager.current_color()
	print("OI!")
	
func _unhandled_input(event):
	if Input.is_action_pressed("mouse_leftbtn"):
		var selected_coord = world_to_map(get_local_mouse_position())
		if planting_mode or increase_garden_mode:
			
			if $SelectedTiles.get_cell(selected_coord.x, selected_coord.y) == SELECTION_TILE_HOVER_ID:
				if planting_mode:
					var seed_obj : Plant = PlayerState.inventory_get_item(PlayerState._holding_item)["seed_obj"]
					var crop_id : String = get_crop_id_by_coord(selected_coord)
					var plant: Plant = PlantFactory.clone_plant(seed_obj)
					plant_crop(crop_id, plant)
				else:
					add_new_crop_area(selected_coord)
				
				PlayerState.hold_item_used()
				end_selection_mode()
			else:
				PlayerState.hold_item_cancel()
				end_selection_mode()
		else:
			var crop_id: String = get_crop_id_by_coord(selected_coord)
			if (crop_tiles.has(crop_id) and crop_tiles[crop_id].plant):
				var plant: Plant = crop_tiles[crop_id].plant
				show_popup_plant(plant)
		
	if event is InputEventMouseMotion:
		if planting_mode or increase_garden_mode:
			var selected_coord = world_to_map(get_local_mouse_position())
			
			if selected_tile != selected_coord:
				$SelectedTiles.set_cell(selected_tile.x, selected_tile.y, SELECTION_TILE_ID)
				
				if $SelectedTiles.get_cell(selected_coord.x, selected_coord.y) == SELECTION_TILE_ID:
					$SelectedTiles.set_cell(selected_coord.x, selected_coord.y, SELECTION_TILE_HOVER_ID)
					selected_tile = selected_coord
				else:
					selected_tile = OUTBOUND_TILE

func _on_PlayerState_planting_mode():
	planting_mode = true
	for tile_data in crop_tiles.values():
		if tile_data["plant"] == null:
			var tile_pos : Vector2 = tile_data["coord"]
			$SelectedTiles.set_cell(tile_pos.x, tile_pos.y, SELECTION_TILE_ID)
	
func _on_PlayerState_edit_garden_mode():
	increase_garden_mode = true
	
	for tile_data in crop_tiles.values():
		var tile_pos : Vector2 = tile_data["coord"]
		
		var x = tile_pos.x - 1
		var y = tile_pos.y
		if get_cell(x, y) == GRASS_TILE_ID and $SelectedTiles.get_cell(x, y) == -1:
			$SelectedTiles.set_cell(x, y, SELECTION_TILE_ID)
			
		x = tile_pos.x 
		y = tile_pos.y - 1
		if get_cell(x, y) == GRASS_TILE_ID and $SelectedTiles.get_cell(x, y) == -1:
			$SelectedTiles.set_cell(x, y, SELECTION_TILE_ID)
			
		x = tile_pos.x + 1
		y = tile_pos.y
		if get_cell(x, y) == GRASS_TILE_ID and $SelectedTiles.get_cell(x, y) == -1:
			$SelectedTiles.set_cell(x, y, SELECTION_TILE_ID)
			
		x = tile_pos.x
		y = tile_pos.y + 1
		if get_cell(x, y) == GRASS_TILE_ID and $SelectedTiles.get_cell(x, y) == -1:
			$SelectedTiles.set_cell(x, y, SELECTION_TILE_ID)

func _on_WorldManager_time_changed() -> void:
	var color = WorldManager.current_color()
	$Tween.interpolate_property(
		self, "modulate",
		self.modulate, color, 
		Constants.TIME_TRANSITION_DURATION,
		Constants.TIME_TRANSITION_CURVE, Constants.TIME_TRANSITION_EASE
	)
	$Tween.start()

func end_selection_mode():
	planting_mode = false
	increase_garden_mode = false
	selected_tile = OUTBOUND_TILE
	
	for y in range(MIN_Y, MAX_Y+1):
		for x in range(MIN_X, MAX_X):
			$SelectedTiles.set_cell(x, y, -1)
	
func plant_crop(crop_id: String, plant: Plant):
	Utils.conn_nodes(WorldManager, "new_day", plant, "age", [1])
	crop_tiles[crop_id]["plant"] = plant
	plant.plant()
	var new_coord = crop_tiles[crop_id].coord
	
	var overview_plant = OVERVIEW_PLANT_SCENE.instance()
	overview_plant.set_age(plant.life_stage)
	
	var feature_name = DNA.get_feature_name(DNA.FEATURES.FLOWER_COLOR)
	var flower_color = plant.phenotype[feature_name]
	var colors = DNA.get_colors(feature_name, flower_color)
	var color = Utils.mix_colors(colors)
	overview_plant.set_flower_color(color)
	
	add_child(overview_plant)
	overview_plant.position = map_to_world(new_coord) + cell_size/2
	
	plant.overview_plant = overview_plant
	print(crop_tiles[crop_id])

func add_new_crop_area(coord: Vector2):
	var new_crop_id : int = int(crop_tiles.keys()[-1])+1
	
	crop_tiles[String(new_crop_id)] = {
		"coord" : coord,
		"plant" : null
	}
	
	# warning-ignore:narrowing_conversion
	# warning-ignore:narrowing_conversion
	set_cell(coord.x, coord.y, PLANT_TILE_ID)
	update_bitmask_area(coord)
	
func get_garden_center():
	var middle_x = (MAX_X + MIN_X)*cell_size.x/2
	var middle_y = (MAX_Y + MIN_Y)*cell_size.y/2
	return Vector2(middle_x, middle_y)

func draw_garden_tiles():
	for tile_data in crop_tiles.values():
		var tile_pos : Vector2 = tile_data["coord"]
		# warning-ignore:narrowing_conversion
		# warning-ignore:narrowing_conversion
		set_cell(tile_pos.x, tile_pos.y, PLANT_TILE_ID)
		update_bitmask_area(Vector2(tile_pos.x, tile_pos.y))

func draw_grass_area():
	for y in range(MIN_Y, MAX_Y+1):
		for x in range(MIN_X, MAX_X):
			set_cell(x, y, GRASS_TILE_ID)
	
func init_garden():
	crop_tiles = {
		"0" : {
			"coord" : Vector2(0, 0),
			"plant" : null
		},
		"1": {
			"coord" : Vector2(0, 1),
			"plant" : null
		},
	}

func get_crop_id_by_coord(coord: Vector2) -> String:
	for key in crop_tiles:
		if crop_tiles[key]["coord"] == coord:
			return key
	
	return ""
	
func save_stats():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : global_transform.origin.x,
		"pos_y" : global_transform.origin.y
	}
	return save_dict
	
func load_stats(stats):
	global_transform.origin = Vector2(stats.pos_x, stats.pos_y)
	
	#draw_grass_area()
	#draw_garden_tiles()
	
	get_child(0).update_position()

func show_popup_plant(plant: Plant) -> void:
	emit_signal("show_close_up_plant", plant)
	
