extends Node

enum TimeOfDay {DAY, NIGHT}

# Day and Time variables
export var _day: int
export(TimeOfDay) var _time: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_day = 1
	_time = TimeOfDay.DAY

func next_day() -> void:
	_day += 1

func pass_time() -> void:
	# Next time of day
	_time = (_time + 1) % TimeOfDay.size()
	
	if _time == TimeOfDay.DAY:
		next_day()

func save_stats() -> Dictionary:
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"day" : _day,
		"time" : _time
	}
	return save_dict

func load_stats(stats: Dictionary) -> void:
	print_debug("LOADING WORLD STATS")
	print_debug(stats)
	_day = stats.day
	_time = stats.time
