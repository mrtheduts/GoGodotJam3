extends Node

# Enums for world conditions
enum TimeOfDay {DAY, NIGHT}
enum Weather {CLEAR, CLOUDY, RAINY, METEOR}

# Day and Time variables
export var _day: int
export(TimeOfDay) var _time: int

# Weather variables
# TODO: better way of initializing probs?
export(Weather) var _weather: int
export(PoolRealArray) var _weather_probs = [0.7, 0.2, 0.1, 0.00001]
var _weather_objects: Array
var _total_weather_weight: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_day = 1
	_time = TimeOfDay.DAY
	_weather = Weather.CLEAR
	
	# Weather probabilities
	_weather_objects = Utils.create_prob_dicts(_weather_probs)
	_total_weather_weight = Utils.init_probabilities(_weather_objects)

func next_day() -> void:
	_day += 1

func pass_time() -> void:
	# Next time of day
	_time = (_time + 1) % TimeOfDay.size()
	
	# Get random weighted weather. For safety reasons, clamp the result.
	# warning-ignore:narrowing_conversion
	_weather = Utils.weighted_random_object(_weather_objects, _total_weather_weight)
	_weather = clamp(_weather, 0, Weather.size())
	
	emit_signal("time_changed")

	if _time == TimeOfDay.DAY:
		next_day()

func world_info() -> Dictionary:
	return {"day":_day, "time":_time}

func _to_string() -> String:
	return "Day: " + String(_day) + "\n" + TimeOfDay.keys()[_time].capitalize()

func save_stats() -> Dictionary:
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"day" : _day,
		"time" : _time,
		"weather": _weather
	}
	return save_dict

func load_stats(stats: Dictionary) -> void:
	print_debug("LOADING WORLD STATS")
	print_debug(stats)
	_day = stats.day
	_time = stats.time
	_weather = stats.weather
