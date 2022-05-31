#
# CloseUpFactory.gd - Creator of CloseUpPlants
#

extends Node

var CLOSE_UP_PLANT_SCENE = preload("res://src/CloseUpPlant/CloseUpPlant.tscn")

func _get_build_parts_from_plant(plant: Plant) -> Dictionary:
	var build_parts := {}
	for feature in plant.phenotype.keys():
		var feature_type = DNA.get_type(feature)
		var gene = plant.phenotype[feature]
		match feature_type:
			DNA.COLOR:
				var colors = DNA.get_colors(feature, gene)
				gene = Utils.mix_colors(colors)
			DNA.SCENE:
				gene = DNA.get_scene(feature, gene)
			DNA.BOOL:
				gene = Utils.as_bool(gene)
		build_parts[DNA.get_feature_value(feature)] = gene
	return build_parts

func _build_adult_plant(close_up_plant: CloseUpPlant, build_parts: Dictionary) -> void:
	var stalk: Stalk = build_parts[DNA.FEATURES.STALK_TYPE].instance()
	close_up_plant.add_child(stalk)
	
	var root: Root = build_parts[DNA.FEATURES.ROOT_TYPE].instance()
	stalk.add_to_skel_down(root)
	
	var branches := []
	if (true): # Has branches
		for n in 2:
			branches.push_back(build_parts[DNA.FEATURES.BRANCH_TYPE].instance())
		stalk.add_to_skel_up(branches[0])
		branches[0].rotation = PI/2
		stalk.add_to_skel_mid(branches[1])
		branches[1].rotation = PI/4
		branches[1].scale.x *= -1
	
	var leaves := []
	for n in 4:
		leaves.push_back(build_parts[DNA.FEATURES.LEAF_TYPE].instance())
	stalk.add_to_skel_down(leaves[0])
	branches[0].add_to_end_bone(leaves[1])
	leaves[1].scale.x *= -1
	branches[1].add_to_end_bone(leaves[2])
	leaves[2].scale.x *= -1
	stalk.add_to_skel_top(leaves[3])
	leaves[3].scale.x *= -1
	
	if (build_parts[DNA.FEATURES.HAS_FLOWER]):
		var flower = build_parts[DNA.FEATURES.FLOWER_TYPE].instance()
		branches[0].add_to_mid_bone(flower)
		
	if (build_parts[DNA.FEATURES.HAS_FRUIT]):
		var fruit = build_parts[DNA.FEATURES.FRUIT_TYPE].instance()
		branches[1].add_to_mid_bone(fruit)
	

func create_close_up_plant_from(plant: Plant) -> CloseUpPlant:
	var close_up_plant: CloseUpPlant = CLOSE_UP_PLANT_SCENE.instance()
	var build_parts = _get_build_parts_from_plant(plant)
	match plant.life_stage:
		Plant.LIFE_STAGES.SEED:
			pass
		Plant.LIFE_STAGES.SPROUT:
			pass
		Plant.LIFE_STAGES.GROWN:
			pass
		Plant.LIFE_STAGES.ADULT:
			_build_adult_plant(close_up_plant, build_parts)
		Plant.LIFE_STAGES.DEAD:
			pass
	return close_up_plant
