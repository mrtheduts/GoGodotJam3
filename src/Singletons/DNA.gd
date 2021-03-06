#
# DNA.gd - Singleton to define genetic elements
#

extends Node

var NUM_ALLELES: int = 2 # This can be increased for more difficulty (more plants needed for crossing)

# Postfixes for FEATURES names
const VALUES_POSTFIX := "_VALUES"
const DOM_POSTFIX := "_DOMINANTS"
const MAPPING_POSTFIX := "_MAPPING"
const SCENES_POSTFIX := "_SCENES"
const TYPE_POSTFIX := "_TYPE"
const REQ_POSTFIX := "_REQUIREMENTS"

# Type literals
const BOOL := "bool"
const COLOR := "Color"
const SCENE := "PackedScene"

# Features definition
enum FEATURES {
	HAS_FLOWER
	FLOWER_COLOR,
	HAS_FRUIT,
	FRUIT_COLOR,
	ROOT_TYPE,
	STALK_TYPE,
	BRANCH_TYPE,
	LEAF_TYPE,
	FLOWER_TYPE,
	FRUIT_TYPE,
	SEED_TYPE
}

# Flower
const HAS_FLOWER_TYPE := BOOL
enum HAS_FLOWER_VALUES { false, true }
const HAS_FLOWER_DOMINANTS := [ HAS_FLOWER_VALUES.true ]

const FLOWER_COLOR_TYPE := COLOR
enum FLOWER_COLOR_VALUES { RED, GRN, BLU, WHT, BLK }
var FLOWER_COLOR_MAPPING := {
	FLOWER_COLOR_VALUES.RED: Color.red,
	FLOWER_COLOR_VALUES.GRN: Color.green,
	FLOWER_COLOR_VALUES.BLU: Color.blue,
	FLOWER_COLOR_VALUES.WHT: Color.white,
	FLOWER_COLOR_VALUES.BLK: Color.black
}

# Fruit
const HAS_FRUIT_TYPE := BOOL
enum HAS_FRUIT_VALUES { false, true }
const HAS_FRUIT_DOMINANTS := [ HAS_FRUIT_VALUES.false ]
const HAS_FRUIT_REQUIREMENTS := {
	FEATURES.HAS_FLOWER: HAS_FLOWER_VALUES.true
}

const FRUIT_COLOR_TYPE := COLOR
enum FRUIT_COLOR_VALUES { RED, GRN, BLU, WHT, BLK }
var FRUIT_COLOR_MAPPING := {
	FRUIT_COLOR_VALUES.RED: Color.red,
	FRUIT_COLOR_VALUES.GRN: Color.green,
	FRUIT_COLOR_VALUES.BLU: Color.blue,
	FRUIT_COLOR_VALUES.WHT: Color.white,
	FRUIT_COLOR_VALUES.BLK: Color.black
}

# Root
const ROOT_TYPE_TYPE := SCENE
enum ROOT_TYPE_VALUES {
	DEFAULT,
	BULB,
	TUBER
}
const ROOT_TYPE_DOMINANTS := [ ROOT_TYPE_VALUES.DEFAULT ]
var ROOT_TYPE_SCENES = {
	ROOT_TYPE_VALUES.DEFAULT: preload("res://src/CloseUpPlant/Roots/FibrousRoot.tscn"),
	ROOT_TYPE_VALUES.BULB: preload("res://src/CloseUpPlant/Roots/BulbRoot.tscn"),
	ROOT_TYPE_VALUES.TUBER: preload("res://src/CloseUpPlant/Roots/TuberRoot.tscn")
}

# Stalk
const STALK_TYPE_TYPE := SCENE
enum STALK_TYPE_VALUES {
	DEFAULT,
	BAMBOO,
	CACTUS,
	WINDING
}
const STALK_TYPE_DOMINANTS := [
	STALK_TYPE_VALUES.DEFAULT,
	STALK_TYPE_VALUES.WINDING
]
var STALK_TYPE_SCENES = {
	STALK_TYPE_VALUES.DEFAULT: preload("res://src/CloseUpPlant/Stalks/DefaultStalk.tscn"),
	STALK_TYPE_VALUES.BAMBOO: preload("res://src/CloseUpPlant/Stalks/BambooStalk.tscn"),
	STALK_TYPE_VALUES.CACTUS: preload("res://src/CloseUpPlant/Stalks/CactusStalk.tscn"),
	STALK_TYPE_VALUES.WINDING: preload("res://src/CloseUpPlant/Stalks/WindingStalk.tscn")
}

# Branch
const BRANCH_TYPE_TYPE := SCENE
enum BRANCH_TYPE_VALUES {
	DEFAULT,
	CACTUS,
	WAVY
}
const BRANCH_TYPE_DOMINANTS := [
	BRANCH_TYPE_VALUES.DEFAULT,
	BRANCH_TYPE_VALUES.WAVY
]
var BRANCH_TYPE_SCENES = {
	BRANCH_TYPE_VALUES.DEFAULT: preload("res://src/CloseUpPlant/Branches/DefaultBranch.tscn"),
	BRANCH_TYPE_VALUES.CACTUS: preload("res://src/CloseUpPlant/Branches/CactusBranch.tscn"),
	BRANCH_TYPE_VALUES.WAVY: preload("res://src/CloseUpPlant/Branches/WavyBranch.tscn")
}

# Leaf
const LEAF_TYPE_TYPE := SCENE
enum LEAF_TYPE_VALUES {
	DEFAULT,
	BIG,
	CURLY,
	FAN,
	THIN,
	THORN,
	WING,
}
const LEAF_TYPE_DOMINANTS := [
	LEAF_TYPE_VALUES.DEFAULT,
	LEAF_TYPE_VALUES.FAN,
	LEAF_TYPE_VALUES.THORN,
	LEAF_TYPE_VALUES.WING
]
var LEAF_TYPE_SCENES = {
	LEAF_TYPE_VALUES.DEFAULT: preload("res://src/CloseUpPlant/Leaves/DefaultLeaf.tscn"),
	LEAF_TYPE_VALUES.BIG: preload("res://src/CloseUpPlant/Leaves/BigLeaf.tscn"),
	LEAF_TYPE_VALUES.CURLY: preload("res://src/CloseUpPlant/Leaves/CurlyLeaf.tscn"),
	LEAF_TYPE_VALUES.FAN: preload("res://src/CloseUpPlant/Leaves/FanLeaf.tscn"),
	LEAF_TYPE_VALUES.THIN: preload("res://src/CloseUpPlant/Leaves/ThinLeaf.tscn"),
	LEAF_TYPE_VALUES.THORN: preload("res://src/CloseUpPlant/Leaves/ThornLeaf.tscn"),
	LEAF_TYPE_VALUES.WING: preload("res://src/CloseUpPlant/Leaves/WingLeaf.tscn"),
}

# Flower
const FLOWER_TYPE_TYPE := SCENE
enum FLOWER_TYPE_VALUES {
	DEFAULT,
	WIDE,
	SAD,
	WEIRD,
	SPLASH,
	TULIP
}
const FLOWER_TYPE_DOMINANTS := [
	FLOWER_TYPE_VALUES.DEFAULT,
	FLOWER_TYPE_VALUES.TULIP,
	FLOWER_TYPE_VALUES.WIDE
]
var FLOWER_TYPE_SCENES = {
	FLOWER_TYPE_VALUES.DEFAULT: preload("res://src/CloseUpPlant/Flowers/DefaultFlower.tscn"),
	FLOWER_TYPE_VALUES.WIDE: preload("res://src/CloseUpPlant/Flowers/WideFlower.tscn"),
	FLOWER_TYPE_VALUES.SAD: preload("res://src/CloseUpPlant/Flowers/SadFlower.tscn"),
	FLOWER_TYPE_VALUES.WEIRD: preload("res://src/CloseUpPlant/Flowers/WeirdFlower.tscn"),
	FLOWER_TYPE_VALUES.SPLASH: preload("res://src/CloseUpPlant/Flowers/SplashFlower.tscn"),
	FLOWER_TYPE_VALUES.TULIP: preload("res://src/CloseUpPlant/Flowers/TulipFlower.tscn")
}

# Fruit
const FRUIT_TYPE_TYPE := SCENE
enum FRUIT_TYPE_VALUES {
	DEFAULT,
	BERRIES,
	FOLIATE,
	PINMYAPPLE,
	QUARTET,
	STRAWBERRY,
}
const FRUIT_TYPE_DOMINANTS := [
	FRUIT_TYPE_VALUES.DEFAULT,
	FRUIT_TYPE_VALUES.FOLIATE,
	FRUIT_TYPE_VALUES.QUARTET,
]
var FRUIT_TYPE_SCENES = {
	FRUIT_TYPE_VALUES.DEFAULT: preload("res://src/CloseUpPlant/Fruits/DefaultFruit.tscn"),
	FRUIT_TYPE_VALUES.BERRIES: preload("res://src/CloseUpPlant/Fruits/BerriesFruit.tscn"),
	FRUIT_TYPE_VALUES.FOLIATE: preload("res://src/CloseUpPlant/Fruits/FoliateFruit.tscn"),
	FRUIT_TYPE_VALUES.PINMYAPPLE: preload("res://src/CloseUpPlant/Fruits/PinMyAppleFruit.tscn"),
	FRUIT_TYPE_VALUES.QUARTET: preload("res://src/CloseUpPlant/Fruits/QuartetFruit.tscn"),
	FRUIT_TYPE_VALUES.STRAWBERRY: preload("res://src/CloseUpPlant/Fruits/StrawberryFruit.tscn"),
}

# Seed
enum SEED_TYPE_VALUES { BEAN, FALL, UNIT, GRAIN, GRAVITY, DRY }
const SEED_TYPE_DOMINANTS := [ 
	SEED_TYPE_VALUES.BEAN,
	SEED_TYPE_VALUES.UNIT,
	SEED_TYPE_VALUES.GRAIN
]

#
# Functions
#
func get_value(feature: String):
	return get(feature + VALUES_POSTFIX)

func get_type(feature: String):
	return get(feature + TYPE_POSTFIX)

func get_colors(feature: String, genes: Array) -> Array:
	var values_enum = get(feature + VALUES_POSTFIX)
	var mapping_enum = get(feature + MAPPING_POSTFIX)
	var colors := []
	
	for gene in genes:
		var gene_value = values_enum[gene]
		var color = mapping_enum[gene_value]
		colors.push_back(color)
	
	return colors

func get_scene(feature: String, gene: String):
	var values_enum = get(feature + VALUES_POSTFIX)
	var mapping_enum = get(feature + SCENES_POSTFIX)
	var gene_value = values_enum[gene]
	return mapping_enum[gene_value]

func get_gene_value(feature: int, gene: String) -> int:
	var feature_name = get_feature_name(feature)
	var value_mapping = get_value(feature_name)
	return value_mapping[gene]

func get_feature_name(value: int) -> String:
	return FEATURES.keys()[value]
func get_feature_value(feature: String) -> int:
	return FEATURES[feature]

func get_gene_mapping(feature, gene: String):
	return get(feature + MAPPING_POSTFIX)[gene]

func get_number_of_genes_in_feature(feature: String) -> int:
	return get(feature + VALUES_POSTFIX).keys().size()

func is_feature_mixable(feature) -> bool:
	return get(feature + DOM_POSTFIX) == null

func is_gene_dominant(feature, gene) -> bool:
	var gene_value = get(feature + VALUES_POSTFIX)[gene]
	return gene_value in get(feature + DOM_POSTFIX)
