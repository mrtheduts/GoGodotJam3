extends MarginContainer

var ICON_DAY_TEXTURE = preload("res://icon.png")
var ICON_NIGHT_TEXTURE = preload("res://raw_assets/images/shop/chest.png")

func _ready():
	Utils.conn_nodes(WorldManager, "new_day", self, "_on_WorldManager_new_day")
	Utils.conn_nodes(WorldManager, "time_changed", self, "_on_WorldManager_time_changed")
	set_time()
	set_day()

func _on_WorldManager_new_day():
	set_day()

func _on_WorldManager_time_changed():
	set_time()

func _on_PassTimeButton_pressed():
	WorldManager.pass_time()

func set_day():
	var info = WorldManager.world_info()
	$HBoxContainer/VBoxContainer/Day.text = "Day: " + String(info.day)

func set_time():
	var info = WorldManager.world_info()
	if info.time == WorldManager.TimeOfDay.DAY:
		$HBoxContainer/VBoxContainer/TimeIcon.texture = ICON_DAY_TEXTURE
	elif info.time == WorldManager.TimeOfDay.NIGHT:
		$HBoxContainer/VBoxContainer/TimeIcon.texture = ICON_NIGHT_TEXTURE
	else:
		print("Something went wrong!")
