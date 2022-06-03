#
# Plant.gd - Class for general plant information
#

class_name Plant

# Signals
signal water_level_changed

enum LIFE_STAGES { SEED, SPROUT, TEENAGE, ADULT, DEAD}

var life_duration_stages: Dictionary

var close_up_plant: CloseUpPlant = null

var type_hash: int = 0
var genetics: Dictionary = {}
var phenotype: Dictionary = {}

var life_stage = LIFE_STAGES.SEED
var watered_amount := Constants.MIN_WATERED_AMOUNT

var value := 1

func _init():
	# Build empty genetics dict
	for feature in DNA.FEATURES:
		genetics[feature] = []

func _reveal_phenotype():
	for feature in genetics.keys():
		if (DNA.is_feature_mixable(feature)):
			phenotype[feature] = [] + genetics[feature] # Clone Array
		else:
			phenotype[feature] = get_predominant_gene(feature, genetics[feature])
	
	var features_to_remove := []
	for feature in phenotype.keys():
		var requirements = DNA.get(feature + DNA.REQ_POSTFIX)
		if (requirements != null):
			for req_feature in requirements.keys():
				var req_feat_name = DNA.get_feature_name(req_feature)
				var phen_value = DNA.get_value(req_feat_name)[phenotype[req_feat_name]]
				if (phen_value != requirements.get(req_feature)):
					features_to_remove.push_back(feature)
	
	for feature in features_to_remove:
		phenotype[feature] = DNA.get_value(feature).keys()[0]

func get_predominant_gene(feature, genes: Array):
	# Filtering dominant and recessive genes
	var dom_genes := []
	var rec_genes := []
	
	for gene in genes:
		if (DNA.is_gene_dominant(feature, gene)):
			dom_genes.push_back(gene)
		else:
			rec_genes.push_back(gene)
	
	var res_genes: Array = dom_genes if (not dom_genes.empty()) else rec_genes
	return Utils.shuffle_and_pop_front(res_genes)

func add_gene(feature, gene) -> void:
	var feat_genes: Array = genetics[feature]
	if (feat_genes.size() < DNA.NUM_ALLELES):
		feat_genes.push_back(gene)

func finish_gene_config() -> void:
	type_hash = genetics.hash() # Regenerate id to reflect its DNA
	
	_reveal_phenotype()

func meiosis() -> Dictionary:
	var result := {}
	for feature in genetics.keys():
		var genes: Array = [] + genetics[feature] # Cloning original array
		result[feature] = Utils.shuffle_and_pop_front(genes)
	return result

func age(days: int = 1) -> void:
	match life_stage:
		LIFE_STAGES.SEED:
			life_stage = LIFE_STAGES.SPROUT
		LIFE_STAGES.SPROUT:
			life_stage = LIFE_STAGES.TEENAGE
		LIFE_STAGES.TEENAGE:
			life_stage = LIFE_STAGES.ADULT
		LIFE_STAGES.ADULT:
			life_stage = LIFE_STAGES.DEAD
		LIFE_STAGES.DEAD:
			printerr("I'm dead! :(")
	close_up_plant = CloseUpPlantFactory.create_close_up_plant_from(self)

func water(amount: int = 1) -> void:
	watered_amount = min(watered_amount + amount, Constants.MAX_WATERED_AMOUNT)
	print("New watered amount: ", watered_amount)
	emit_signal("water_level_changed", watered_amount)

func plant() -> void:
	close_up_plant = CloseUpPlantFactory.create_close_up_plant_from(self)
