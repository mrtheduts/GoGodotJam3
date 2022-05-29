#
# DNA.gd - Singleton to define genetic elements
#

extends Node

var NUM_ALLELES: int = 2 # This can be increased for more difficulty (more plants needed for crossing)
const VALUES_POSTFIX := "_VALUES"

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
