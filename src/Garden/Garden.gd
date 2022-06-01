extends TileMap

# Signals
signal show_close_up_plant

# Constants
var PLANT_TILE_ID : int = 0
var GRASS_TILE_ID : int = 1
var X_MARGIN : int = 4
var Y_MARGIN : int = 3

# Variables
var garden_size : int = 4
var plants = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print(garden_size)
	if (len(plants) == 0):
		print("Initing plants from garden")
		init_garden()
	draw_garden_tiles()
	draw_grass_area()
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(garden_size)
	pass

func _unhandled_input(event):
   # Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				var plant: Plant = PlantFactory.gen_random_plant()
				plant.age()
				plant.age()
				print("Plant [", plant.type_hash, "]: ", plant.genetics)
				var close_up_plant: CloseUpPlant = CloseUpPlantFactory.create_close_up_plant_from(plant)
				show_popup_plant(close_up_plant)
#				print("Mouse Click/Unclick at: ", event.position)
#				upgrade_garden_size()
#				print(garden_size)
				
func get_garden_center():
	var middle = garden_size*cell_size.x/2
	return Vector2(middle, middle)
	
func upgrade_garden_size():
	garden_size += 1
	
	upgrade_plants_space()
	draw_garden_tiles()
	draw_grass_area()
	get_child(0).update_position()

func upgrade_plants_space():
	for y in range(garden_size):
		if (y == garden_size-1):
			var newPlantsRow = []
			for _x in range(garden_size):
				newPlantsRow.append(null)
			plants.append(newPlantsRow)
		else:
			plants[y].append(null)

func draw_garden_tiles():
	for x in range(garden_size):
		for y in range(garden_size):
			set_cell(x, y, PLANT_TILE_ID)

func draw_grass_area():
	var first_x = -X_MARGIN
	var first_y = -Y_MARGIN
	
	var max_x = garden_size + X_MARGIN
	var max_y = garden_size + Y_MARGIN
	
	for y in range(first_y, max_y):
		for x in range(first_x, max_x):
			if x >= 0 and x < garden_size and y >= 0 and y < garden_size:
				continue
			else:
				set_cell(x, y, GRASS_TILE_ID)

	
func init_garden():
	for _y in range(garden_size):
		var new_plants_row = []
		for _x in range(garden_size):
			new_plants_row.append(null)
		plants.append(new_plants_row)
		
		
func save_stats():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : global_transform.origin.x,
		"pos_y" : global_transform.origin.y,
		"garden_size" : garden_size,
		"plants" : plants
	}
	return save_dict
	
func load_stats(stats):
	global_transform.origin = Vector2(stats.pos_x, stats.pos_y)
	garden_size = stats.garden_size
	plants = stats.plants
	
	draw_garden_tiles()
	draw_grass_area()
	
	get_child(0).update_position()

func show_popup_plant(close_up_plant: CloseUpPlant) -> void:
	emit_signal("show_close_up_plant", close_up_plant)
	
