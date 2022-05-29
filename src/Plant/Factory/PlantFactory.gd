#
# PlantFactory.gd - Generator of plants
#

extends Node

var PLANT_CLASS = preload("res://src/Plant/Plant.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	var plant_a = gen_random_plant()
	print("Plant A (Type: ", plant_a.type_hash, ") ", plant_a.genetics)
	var plant_b = gen_random_plant()
	print("Plant B (Type: ", plant_b.type_hash, ") ", plant_b.genetics)
	var child_plant = cross_plants([plant_a, plant_b])
	print("Child Plant (Type: ", child_plant.type_hash, ") ", child_plant.genetics)
	var cloned = clone_plant(child_plant)
	print("Cloned from child (Type: ", cloned.type_hash, ") ", cloned.genetics)

func gen_random_plant() -> Plant:
	var new_plant: Plant = PLANT_CLASS.new()
	for feature in DNA.FEATURES:
		for n in DNA.NUM_ALLELES:
			randomize()
			var feature_values: Array = DNA[feature + DNA.VALUES_POSTFIX].keys()
			feature_values.shuffle()
			
			var gene = feature_values.pop_front()
			new_plant.add_gene(feature, gene)
	return new_plant

func clone_plant(plant: Plant, life_stage = Plant.LIFE_STAGES.SEED) -> Plant:
	var new_plant: Plant = PLANT_CLASS.new()
	new_plant.life_stage = life_stage
	new_plant.genetics = plant.genetics.duplicate(true)
	new_plant.type_hash = new_plant.genetics.hash()
	return new_plant

func cross_plants(plants: Array, can_mutate: bool = true) -> Plant:
	# Each parent provides one allele
	if (plants.size() != DNA.NUM_ALLELES):
		return null
	
	var new_plant: Plant = PLANT_CLASS.new()
	for plant in plants:
		plant = plant as Plant
		var genes = plant.meiosis()
		for feature in genes:
			var gene = genes[feature]
			if (can_mutate and did_mutation_happen()):
				var mutated_gene = get_random_gene_different_from(feature, gene)
				print("A mutation happened with ", feature, " and replaced ", gene, " with a ", mutated_gene, "!")
				gene = mutated_gene
			new_plant.add_gene(feature, gene)
	
	return new_plant

func did_mutation_happen() -> bool:
	randomize()
	return rand_range(1, Constants.MUTATION_ODDS) as int == 1

func get_random_gene_different_from(feature, gene):
	var new_gene = get_random_gene(feature)
	while (new_gene == gene):
		new_gene = get_random_gene(feature)
	return new_gene

func get_random_gene(feature):
	randomize()
	var values: Array = DNA[feature + DNA.VALUES_POSTFIX].keys()
	var rand_index = rand_range(0, values.size()) as int
	return values[rand_index]

