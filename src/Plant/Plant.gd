#
# Plant.gd - Class for general plant information
#

class_name Plant

enum LIFE_STAGES { SEED, SPROUT, GROWN, ADULT, DEAD}

var type_hash: int = 0
var genetics: Dictionary = {}

var life_stage = LIFE_STAGES.SEED

func _init():
	# Build empty genetics dict
	for feature in DNA.FEATURES:
		genetics[feature] = []

func add_gene(feature, gene) -> void:
	var feat_genes: Array = genetics[feature]
	if (feat_genes.size() < DNA.NUM_ALLELES):
		feat_genes.push_back(gene)
	type_hash = genetics.hash() # Regenerate id to reflect its DNA

func replate_gene_at(feature, index, new_gene) -> void:
	var feat_genes: Array = genetics[feature]
	if (index < feat_genes.size()):
		feat_genes[index] = new_gene
	type_hash = genetics.hash() # Regenerate id to reflect its DNA

func meiosis() -> Dictionary:
	var result := {}
	for feature in genetics.keys():
		var genes: Array = [] + genetics[feature] # Cloning original array
		randomize()
		genes.shuffle()
		result[feature] = genes.pop_front()
	return result

func age() -> void:
	match life_stage:
		LIFE_STAGES.SEED:
			life_stage = LIFE_STAGES.SPROUT
		LIFE_STAGES.SPROUT:
			life_stage = LIFE_STAGES.GROWN
		LIFE_STAGES.GROWN:
			life_stage = LIFE_STAGES.ADULT
		LIFE_STAGES.ADULT:
			life_stage = LIFE_STAGES.DEAD
		LIFE_STAGES.DEAD:
			printerr("I'm dead! :(")
