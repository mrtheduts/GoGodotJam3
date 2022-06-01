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
	print(plant.phenotype)
	return build_parts

func _build_adult_plant(close_up_plant: CloseUpPlant, build_parts: Dictionary) -> void:
	var stalk: Stalk = build_parts[DNA.FEATURES.STALK_TYPE].instance()
	stalk.start_wind_animation()
	close_up_plant.add_child(stalk)
	
	var root: Root = build_parts[DNA.FEATURES.ROOT_TYPE].instance()
	close_up_plant.add_to_idle_animation_list(root)
	stalk.add_to_skel_down(root)
	
	var branches := []
	if (true): # Has branches
		for n in 2:
			branches.push_back(build_parts[DNA.FEATURES.BRANCH_TYPE].instance())
			close_up_plant.add_to_idle_animation_list(branches[n])
		stalk.add_to_skel_up(branches[0])
		stalk.add_to_skel_mid(branches[1])
		branches[1].scale.x *= -1
	
	var leaves := []
	for n in 2:
		leaves.push_back(build_parts[DNA.FEATURES.LEAF_TYPE].instance())
	stalk.add_to_skel_mid(leaves[0])
	branches[0].add_to_mid_bone(leaves[1])
	
	if (build_parts[DNA.FEATURES.HAS_FLOWER]):
		var flower: Flower = build_parts[DNA.FEATURES.FLOWER_TYPE].instance()
		flower.set_color(build_parts[DNA.FEATURES.FLOWER_COLOR])
		stalk.add_to_skel_top(flower)
		
	if (build_parts[DNA.FEATURES.HAS_FRUIT]):
		var fruit: Fruit = build_parts[DNA.FEATURES.FRUIT_TYPE].instance()
		fruit.set_color(build_parts[DNA.FEATURES.FRUIT_COLOR])
		branches[1].add_to_end_bone(fruit)
	

func create_close_up_plant_from(plant: Plant) -> CloseUpPlant:
	var close_up_plant: CloseUpPlant = CLOSE_UP_PLANT_SCENE.instance()
	var build_parts = _get_build_parts_from_plant(plant)
	match plant.life_stage:
		Plant.LIFE_STAGES.SEED:
			pass
		Plant.LIFE_STAGES.SPROUT:
			pass
		Plant.LIFE_STAGES.ADULT:
			_build_adult_plant(close_up_plant, build_parts)
		Plant.LIFE_STAGES.DEAD:
			pass
	return close_up_plant
