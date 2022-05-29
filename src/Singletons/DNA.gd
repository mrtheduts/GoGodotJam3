#
# DNA.gd - Singleton to define genetic elements
#

extends Node

const NUM_ALLELES: int = 2

enum FEATURES {
	HAS_FLOWER
	FLOWER_COLOR,
	HAS_FRUIT,
	FRUIT_COLOR
}

# Flower
enum HAS_FLOWER_VALUES { false, true }
enum FLOWER_COLOR_VALUES { RED, GRN, BLU, WHT, BLK }

# Fruit
enum HAS_FRUIT_VALUES { false, true }
enum FRUIT_COLOR_VALUES { RED, GRN, BLU, WHT, BLK }
