#
# Plant.gd - Class for general plant information
#

class_name Plant

# Signals
signal water_level_changed
signal ask_for_close_up_plant
signal plant_is_adult
signal update_ui

const BASE_VALUE : int = 5

var life_duration_stages: Dictionary

var close_up_plant: CloseUpPlant = null
var overview_plant: OverviewPlant = null

var type_hash: int = 0
var phenotype_hash: int = 0
var genetics: Dictionary = {}
var phenotype: Dictionary = {}

var life_stage = Constants.LIFE_STAGES.SEED
var life_days := 0
var days_without_water := 0
var watered_amount := Constants.MIN_WATERED_AMOUNT

var value := BASE_VALUE

var last_photo: Image = null
var name: String = Constants.DEFAULT_PLANT_NAME

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
	phenotype_hash = phenotype.hash()
	set_plant_value()
	
func meiosis() -> Dictionary:
	var result := {}
	for feature in genetics.keys():
		var genes: Array = [] + genetics[feature] # Cloning original array
		result[feature] = Utils.shuffle_and_pop_front(genes)
	return result

func age(days: int) -> void:
	life_days += days
	
	if watered_amount >= Constants.MIN_WATER_TO_AGE:
		match life_stage:
			Constants.LIFE_STAGES.SEED:
				life_stage = Constants.LIFE_STAGES.SPROUT
				set_plant_value()
			Constants.LIFE_STAGES.SPROUT:
				life_stage = Constants.LIFE_STAGES.TEENAGE
				set_plant_value()
			Constants.LIFE_STAGES.TEENAGE:
				life_stage = Constants.LIFE_STAGES.ADULT
				set_plant_value()
			Constants.LIFE_STAGES.ADULT:
				life_stage = Constants.LIFE_STAGES.DEAD
				value = 0
				close_up_plant.die()
		
		emit_signal("update_ui", life_stage)
		overview_plant.set_age(life_stage)
		emit_signal("ask_for_close_up_plant", self)
	
	if watered_amount > 0:
		water(-1)

func water(amount: int = 1) -> void:
	# warning-ignore:narrowing_conversion
	watered_amount = min(watered_amount + amount, Constants.MAX_WATERED_AMOUNT)
	print("New watered amount: ", watered_amount)
	emit_signal("water_level_changed", watered_amount)
	
func set_plant_value() -> void:
	if life_stage == Constants.LIFE_STAGES.SEED:
		value = get_seed_value()
	else:
		var rec_phenotype_count := 0
		for feature in phenotype.keys():
			if (!DNA.is_feature_mixable(feature)):
				if (!DNA.is_gene_dominant(feature, phenotype[feature])):
					rec_phenotype_count += 1
		value = life_stage * (BASE_VALUE + pow(rec_phenotype_count, 2))
	
func get_seed_value() -> int:
	var rec_genes_count := 0
	for feature in genetics.keys():
		if (!DNA.is_feature_mixable(feature)):
			for gene in genetics[feature]:
				if (!DNA.is_gene_dominant(feature, gene)):
					rec_genes_count += 1
	
	return rec_genes_count + BASE_VALUE
		
func plant() -> void:
	emit_signal("ask_for_close_up_plant", self)

# Get identifer code for unique seed
func get_seed_code() -> String:
	var fruit_colors : Array = genetics["FRUIT_COLOR"]
	var flower_colors : Array = genetics["FLOWER_COLOR"]
	
	return fruit_colors[0][0] + fruit_colors[1][0] + flower_colors[0][0] + flower_colors[1][0] 
