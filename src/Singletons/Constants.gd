#
# Constants.gd - Constants for entire project
#
class_name Constants

const STARTING_MONEY: int = 10
const STARTING_STORAGE_SPACE: int = 5

const TRANSITION_DURATION: float = 1.0

# WORLD COLORS

# TIME
const DAY_COLOR = Color.white
const NIGHT_COLOR = Color.midnightblue
const DAY_COLOR_FACTOR = 0.0
const NIGHT_COLOR_FACTOR = 0.2

const TIME_TRANSITION_DURATION = 0.8
const TIME_TRANSITION_CURVE = Tween.TRANS_LINEAR
const TIME_TRANSITION_EASE = Tween.EASE_IN_OUT

# WEATHER
const CLOUDY_COLOR = Color.black
const RAINY_COLOR = Color.black
const METEOR_COLOR = Color.red

const CLOUDY_COLOR_FACTOR = 0.1
const RAINY_COLOR_FACTOR = 0.1
const METEOR_COLOR_FACTOR = 0.0

# PLANT
enum LIFE_STAGES { SEED, SPROUT, TEENAGE, ADULT, DEAD}
const NUM_CHILDREN_PER_ENTRY := 2

const ZOOM_IN_LIFE_STAGES := {
	LIFE_STAGES.SEED: 3.0,
	LIFE_STAGES.SPROUT: 5.0,
	LIFE_STAGES.TEENAGE: 7.0,
	LIFE_STAGES.ADULT: 12.0,
	LIFE_STAGES.DEAD: 12.0,
}

const Z_INDEX_ROOT := -1
const Z_INDEX_STALK := 0
const Z_INDEX_BRANCH := -2
const Z_INDEX_LEAF := -1
const Z_INDEX_FLOWER := 2
const Z_INDEX_FRUIT := 1

const ADULT_STAGE_DAYS: int = 4

const DEAD_LEAF_COLOR := Color('#ff6464')
const DEAD_COLOR := Color("#add5ff")
const DYING_DURATION := 5

const MUTATION_ODDS = 100

const MIN_TIME_WATERING: float = 5.0
const MAX_WATERED_AMOUNT: int = 10
const MIN_WATERED_AMOUNT: int = 1
const MIN_WATER_TO_AGE: int = 3

# SHOP
const SHOP_WELCOME_TEXT = "Hello farmer! Want to check today's goodies?\n"
const SHOP_HOE_TEXT = "This is the best Hoe you can find on market right now. Great to expand your flower bed area.\nBuy this for only %s coins!"
const SHOP_CHEST_TEXT = "This is a mysterious chest I found on my trips.\nNot sure what it does, but you may find use for it. Only %s coins."
const SHOP_BAG_TEXT = "Buying all the seeds you see, but don't have enough space?\nBuy this seed bag for only %s coins!"
const SHOP_SEED_TEXT = "A nice seed packet with 4 seeds inside.\n Only %s coins. Interested?"
const SHOP_THANKS_TEXT = "Thanks for your purchase!"
const SHOP_WARN_TEXT = "Oops. I think you don't have enough %s right now. Come back when you do, okay?"

# ITEMS
const HOE_ITEM_ID : int = 1
const SEED_ITEM_ID : int = 4

# INDEX
const LOCKED_PLANT_NAME: String = "LOCKED"
const DEFAULT_PLANT_NAME: String = "New Plant"
const INDEX_ENTRIES: int = 20
