#
# CloseUpFactory.gd - Creator of CloseUpPlants
#

extends Node

var CLOSE_UP_PLANT_SCENE = preload("res://src/CloseUpPlant/CloseUpPlant.tscn")
var SEED_SCENE = preload("res://src/CloseUpPlant/Seeds/Seed.tscn")

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

func _build_seed_plant(close_up_plant: CloseUpPlant, build_parts: Dictionary) -> CloseUpPlant:
	var seed_node = SEED_SCENE.instance()
	close_up_plant.add_to_idle_animation_list(seed_node)
	close_up_plant.add_seed(seed_node)
	
	var seed_type_value = DNA.get_gene_value(DNA.FEATURES.SEED_TYPE, build_parts[DNA.FEATURES.SEED_TYPE])
	seed_node.set_type(seed_type_value)
	
	close_up_plant.set_depth_as(Constants.LIFE_STAGES.SEED)
	return close_up_plant

func _build_sprout_plant(close_up_plant: CloseUpPlant, build_parts: Dictionary) -> CloseUpPlant:
	var stalk: Stalk = build_parts[DNA.FEATURES.STALK_TYPE].instance()
	close_up_plant.add_stalk(stalk)
	close_up_plant.add_to_idle_animation_list(stalk)
	
	var root = build_parts[DNA.FEATURES.ROOT_TYPE].instance()
	close_up_plant.add_root(root)
	close_up_plant.add_to_idle_animation_list(root)
	
	var leaf_scene = build_parts[DNA.FEATURES.LEAF_TYPE]
	_fill_with(leaf_scene, close_up_plant)
	
	close_up_plant.move_seed_to_top()
	close_up_plant.set_depth_as(Constants.LIFE_STAGES.SPROUT)
	return close_up_plant

func _build_teenage_plant(close_up_plant: CloseUpPlant, build_parts: Dictionary) -> CloseUpPlant:
	close_up_plant.free_seed()
	close_up_plant.erase_leaves()
	
	close_up_plant.set_depth_as(Constants.LIFE_STAGES.TEENAGE)
	close_up_plant.age()
	
	var branch_number := Utils.randi_range(0, 1)
	var branch_scene = build_parts[DNA.FEATURES.BRANCH_TYPE]
	_fill_with(branch_scene, close_up_plant, branch_number)
	
	var leaf_scene = build_parts[DNA.FEATURES.LEAF_TYPE]
	_fill_with(leaf_scene, close_up_plant)
		
	return close_up_plant

func _build_adult_plant(close_up_plant: CloseUpPlant, build_parts: Dictionary) -> CloseUpPlant:
	close_up_plant.erase_leaves()
	close_up_plant.age()
	
	var branch_number := Utils.randi_range(1, 2)
	var branch_scene = build_parts[DNA.FEATURES.BRANCH_TYPE]
	_fill_with(branch_scene, close_up_plant, branch_number)
	
	if (build_parts[DNA.FEATURES.HAS_FLOWER]):
		var flower_scene = build_parts[DNA.FEATURES.FLOWER_TYPE]
		var flower_color = build_parts[DNA.FEATURES.FLOWER_COLOR]
		var flower_amount = Utils.randi_range(1, 3)
		_fill_with(flower_scene, close_up_plant, flower_amount, true, flower_color)
#
#	if (build_parts[DNA.FEATURES.HAS_FRUIT]):
#		var fruit: Fruit = build_parts[DNA.FEATURES.FRUIT_TYPE].instance()
#		fruit.set_color(build_parts[DNA.FEATURES.FRUIT_COLOR])
#		branches[1].add_to_end_bone(fruit)

	var leaf_scene = build_parts[DNA.FEATURES.LEAF_TYPE]
	_fill_with(leaf_scene, close_up_plant)
	return close_up_plant

func _fill_with(scene, close_up_plant: CloseUpPlant, amount: int = -1, has_color: bool = false, modulate_color: Color = Color.white) -> void:
	var count := 0
	var has_space = true
	while(has_space and (amount == -1 or count < amount)):
		var node = scene.instance()
		if (has_color):
			node.modulate = modulate_color
		
		has_space = close_up_plant.add_to_random_entry_point(node)
		count += 1

func create_close_up_plant_from(plant: Plant) -> CloseUpPlant:
	var close_up_plant: CloseUpPlant = CLOSE_UP_PLANT_SCENE.instance() if not plant.close_up_plant else plant.close_up_plant
	var build_parts = _get_build_parts_from_plant(plant)
	match plant.life_stage:
		Constants.LIFE_STAGES.SEED:
			close_up_plant = _build_seed_plant(close_up_plant, build_parts)
		Constants.LIFE_STAGES.SPROUT:
			close_up_plant = _build_sprout_plant(close_up_plant, build_parts)
		Constants.LIFE_STAGES.TEENAGE:
			close_up_plant = _build_teenage_plant(close_up_plant, build_parts)
		Constants.LIFE_STAGES.ADULT:
			close_up_plant = _build_adult_plant(close_up_plant, build_parts)
		Constants.LIFE_STAGES.DEAD:
			pass
	if (plant.life_stage != Constants.LIFE_STAGES.DEAD):
		close_up_plant.play_idle_animation()
	plant.close_up_plant = close_up_plant
	return close_up_plant
