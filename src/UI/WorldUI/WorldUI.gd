extends MarginContainer

var ICON_DAY_TEXTURE = preload("res://raw_assets/images/ui-icons/sun.png")
var ICON_NIGHT_TEXTURE = preload("res://raw_assets/images/ui-icons/moon.png")

var ICON_CLEAR_TEXTURE = preload("res://raw_assets/images/ui-icons/clear-weather.png")
var ICON_CLOUDY_TEXTURE = preload("res://raw_assets/images/ui-icons/cloudy-weather.png")
var ICON_RAINY_TEXTURE = preload("res://raw_assets/images/ui-icons/rainy-weather.png")
var ICON_METEOR_TEXTURE = preload("res://raw_assets/images/ui-icons/meteor-weather.png")

func _ready():
	Utils.conn_nodes(WorldManager, "new_day", self, "_on_WorldManager_new_day")
	Utils.conn_nodes(WorldManager, "time_changed", self, "_on_WorldManager_time_changed")
	set_time()
	set_day()
	set_weather()

func _on_WorldManager_new_day():
	set_day()

func _on_WorldManager_time_changed():
	set_time()
	set_weather()

func _on_PassTimeButton_pressed():
	WorldManager.pass_time()

func set_day():
	var info = WorldManager.world_info()
	$HBoxContainer/VBoxContainer/Day.text = "Day: " + String(info.day)

func set_time():
	var info = WorldManager.world_info()
	var textureArray = [
		ICON_DAY_TEXTURE,
		ICON_NIGHT_TEXTURE
	]
	if (info.time >= textureArray.size()):
		print("Something very wrong happened!")
		return

	var texture = textureArray[info.time]
	$HBoxContainer/VBoxContainer/HBoxContainer/TimeIcon.texture = texture

func set_weather():
	var info = WorldManager.world_info()
	var textureArray = [
		ICON_CLEAR_TEXTURE,
		ICON_CLOUDY_TEXTURE,
		ICON_RAINY_TEXTURE,
		ICON_METEOR_TEXTURE
	]
	if (info.time >= textureArray.size()):
		print("Something very wrong happened!")
		return
	var texture = textureArray[info.weather]
	$HBoxContainer/VBoxContainer/HBoxContainer/WeatherIcon.texture = texture
