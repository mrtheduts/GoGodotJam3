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
	var stalk = build_parts[DNA.FEATURES.STALK_TYPE].instance()
	close_up_plant.add_stalk(stalk)
	close_up_plant.add_to_idle_animation_list(stalk)
	stalk.set_age(Constants.LIFE_STAGES.SPROUT)
	
	var root = build_parts[DNA.FEATURES.ROOT_TYPE].instance()
	close_up_plant.add_root(root)
	close_up_plant.add_to_idle_animation_list(root)
	
	var leaf_scene = build_parts[DNA.FEATURES.LEAF_TYPE]
	var leaf_entrypoint = close_up_plant.stalk_node.get_stalk_mid()
	_add_leaf_to(leaf_scene, close_up_plant, leaf_entrypoint, Vector2(-1, 1))
	_add_leaf_to(leaf_scene, close_up_plant, leaf_entrypoint)
	
	close_up_plant.move_seed_to_top()
	close_up_plant.set_depth_as(Constants.LIFE_STAGES.SPROUT)
	return close_up_plant

func _build_teenage_plant(close_up_plant: CloseUpPlant, build_parts: Dictionary) -> CloseUpPlant:
	close_up_plant.free_seed()
	close_up_plant.set_depth_as(Constants.LIFE_STAGES.TEENAGE)
	close_up_plant.set_age(Constants.LIFE_STAGES.TEENAGE)
	return close_up_plant

func _build_adult_plant(close_up_plant: CloseUpPlant, build_parts: Dictionary) -> CloseUpPlant:
	var stalk = build_parts[DNA.FEATURES.STALK_TYPE].instance()
	close_up_plant.add_child(stalk)
	
	var root = build_parts[DNA.FEATURES.ROOT_TYPE].instance()
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
	return close_up_plant

func _add_leaf_to(leaf_scene, close_up_plant: CloseUpPlant, parent: Node, scale: Vector2 = Vector2.ONE) -> void:
	var leaf_node = leaf_scene.instance()
	close_up_plant.add_leaf(leaf_node, parent, scale)

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
	close_up_plant.play_idle_animation()
	plant.close_up_plant = close_up_plant
	return close_up_plant
