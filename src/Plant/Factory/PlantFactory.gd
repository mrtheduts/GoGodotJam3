#
# PlantFactory.gd - Generator of plants
#

extends Node

var PLANT_CLASS = preload("res://src/Plant/Plant.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	var plant_a = gen_random_plant()
	print("Plant A: ", plant_a.genetics)
	var plant_b = gen_random_plant()
	print("Plant B: ", plant_b.genetics)
	var child_plant = cross_plants([plant_a, plant_b])
	print("Child Plant: ", child_plant.genetics)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func gen_random_plant() -> Plant:
	var new_plant: Plant = PLANT_CLASS.new()
	for feature in DNA.FEATURES:
		for n in DNA.NUM_ALLELES:
			randomize()
			var feature_values: Array = DNA[feature + "_VALUES"].keys()
			feature_values.shuffle()
			
			var gene = feature_values.pop_front()
			new_plant.add_gene(feature, gene)
	return new_plant

func clone_plant(plant: Plant, life_stage = Plant.LIFE_STAGES.SEED) -> Plant:
	var new_plant: Plant = PLANT_CLASS.new()
	new_plant.life_stage = life_stage
	new_plant.genetics = plant.genetics.duplicate(true)
	return new_plant

func cross_plants(plants: Array) -> Plant:
	if (plants.size() != DNA.NUM_ALLELES):
		return null
	
	var new_plant: Plant = PLANT_CLASS.new()
	for plant in plants:
		plant = plant as Plant
		var genes = plant.meiosis()
		for feature in genes:
			new_plant.add_gene(feature, genes[feature])
	
	return new_plant
