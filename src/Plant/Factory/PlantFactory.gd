#
# PlantFactory.gd - Generator of plants
#

extends Node

var PLANT_CLASS = preload("res://src/Plant/Plant.gd")

#func _ready():
#	var new_plant : Plant = gen_random_plant()
	
func _did_mutation_happen() -> bool:
	randomize()
	return rand_range(1, Constants.MUTATION_ODDS) as int == 1

func _get_random_gene_different_from(feature, gene):
	if (DNA.get_number_of_genes_in_feature(feature) <= 1):
		return gene
	
	var new_gene = gene
	while (new_gene == gene):
		new_gene = _get_random_gene(feature)
	return new_gene

func _get_random_gene(feature):
	randomize()
	var values: Array = DNA[feature + DNA.VALUES_POSTFIX].keys()
	var rand_index = rand_range(0, values.size()) as int
	return values[rand_index]

func gen_random_plant() -> Plant:
	var new_plant: Plant = PLANT_CLASS.new()
	Utils.conn_nodes(new_plant, "ask_for_close_up_plant", $"/root/CloseUpPlantFactory", "create_close_up_plant_from")
	for feature in DNA.FEATURES:
		for n in DNA.NUM_ALLELES:
			var feature_values: Array = DNA[feature + DNA.VALUES_POSTFIX].keys()
			var gene = Utils.shuffle_and_pop_front(feature_values)
			new_plant.add_gene(feature, gene)
	new_plant.finish_gene_config()
	return new_plant

func clone_plant(plant: Plant, life_stage = Constants.LIFE_STAGES.SEED) -> Plant:
	var new_plant: Plant = PLANT_CLASS.new()
	Utils.conn_nodes(new_plant, "ask_for_close_up_plant", $"/root/CloseUpPlantFactory", "create_close_up_plant_from")
	new_plant.life_stage = life_stage
	new_plant.genetics = plant.genetics.duplicate(true)
	new_plant.finish_gene_config()
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
			if (can_mutate and _did_mutation_happen()):
				var mutated_gene = _get_random_gene_different_from(feature, gene)
				print("A mutation happened with ", feature, " and replaced ", gene, " with a ", mutated_gene, "!")
				gene = mutated_gene
			new_plant.add_gene(feature, gene)
	new_plant.finish_gene_config()
	return new_plant
	
func are_plants_equal(plant1: Plant, plant2: Plant):
	if plant1 == null or plant2 == null:
		return false
		
	return plant1.type_hash == plant2.type_hash
