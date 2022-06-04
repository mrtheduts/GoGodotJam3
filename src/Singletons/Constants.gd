#
# Constants.gd - Constants for entire project
#

class_name Constants

const STARTING_MONEY: int = 10
const STARTING_STORAGE_SPACE: int = 5

# PLANT
enum LIFE_STAGES { SEED, SPROUT, TEENAGE, ADULT, DEAD}
const NUM_CHILDREN_PER_ENTRY := 2

const DEAD_LEAF_COLOR := Color('#ff6464')
const DEAD_COLOR := Color("#add5ff")
const DYING_DURATION := 5

const MUTATION_ODDS = 100

const MIN_TIME_WATERING: float = 5.0
const MAX_WATERED_AMOUNT: int = 10
const MIN_WATERED_AMOUNT: int = 1


# SHOP
const SHOP_WELCOME_TEXT = "Hello farmer! Want to check today's goodies?\n"
const SHOP_HOE_TEXT = "This is the best Hoe you can find on market right now. Great to expand your flower bed area.\nBuy this for only %s coins!"
const SHOP_CHEST_TEXT = "This is a mysterious chest I found on my trips.\nNot sure what it does, but you may find use for it. Only %s coins."
const SHOP_BAG_TEXT = "Buying all the seeds you see, but don't have enough space?\nBuy this seed bag for only %s coins!"
const SHOP_SEED_TEXT = "A nice %s seed for only %s coins. Interested?"
const SHOP_THANKS_TEXT = "Thanks for your purchase!"
const SHOP_WARN_TEXT = "Oops. I think you don't have enough money right now. Come back when you do, okay?"
