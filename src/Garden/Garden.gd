extends TileMap


# Constants
var PLANT_TILE_ID = 0
var GRASS_TILE_ID = 1

# Variables
var gardenSize = 4
var cellSize = 128
var plants = []
var tileStart = Vector2(-4, -3)
var tileEnd = Vector2(7,6)

# Called when the node enters the scene tree for the first time.
func _ready():
	initGarden()
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
   # Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if event.is_pressed():
				
			if event.button_index == BUTTON_LEFT:
				print("Mouse Click/Unclick at: ", event.position)
				upgradeGardenSize()
				print(plants)
				print(gardenSize)
				
func getGardenCenter():
	var middle = gardenSize*128/2
	return Vector2(middle, middle)
	
func upgradeGardenSize():
	gardenSize += 1
	
	# Increasing plants array
	for y in range(gardenSize):
		if (y == gardenSize-1):
			var newPlantsRow = []
			for x in range(gardenSize):
				newPlantsRow.append(null)
				set_cell(x, y, PLANT_TILE_ID)
			plants.append(newPlantsRow)
		else:
			plants[y].append(null)
			set_cell(gardenSize-1, y, PLANT_TILE_ID)
	
	increaseGrassArea()
	get_child(0).updatePosition()

func increaseGrassArea():
	var firstX = tileStart.x
	var firstY = tileStart.y
	
	var maxX = tileEnd.x
	var maxY = tileEnd.y
	for y in range(firstY, maxY+1):
		set_cell(maxX+1, y, GRASS_TILE_ID)
	
	for x in range(firstX, maxX+2):
		set_cell(x, maxY+1, GRASS_TILE_ID)
	
	tileEnd = Vector2(maxX+1, maxY+1)
	
func initGarden():
	for _y in range(gardenSize):
		var newPlantsRow = []
		for _x in range(gardenSize):
			newPlantsRow.append(null)
		plants.append(newPlantsRow)

