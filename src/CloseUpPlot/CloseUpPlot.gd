extends Node2D

class_name CloseUpPlot

const WATER_LEVEL_RATE := 0.05
const WATER_COLOR_SPEED := 0.75

var plant
var water_amount := 0

func _ready():
	Utils.conn_nodes(WorldManager, "time_changed", self, "_on_WorldManager_time_changed")
	self.modulate = WorldManager.current_color()

func _process(_delta):
	if $WateringParticles.emitting == true and water_amount >= Constants.MIN_WATER_TO_AGE:
		$Ground/WaterCheckParticles.emitting = true
	else:
		$Ground/WaterCheckParticles.emitting = false

func add_node_and_focus_camera(new_node: Node2D, cam_offset: Vector2 = Vector2.ZERO, cam_zoom: float = 1.0):
	add_child(new_node)
	focus_camera(cam_offset, cam_zoom)

func focus_camera(cam_offset: Vector2 = Vector2.ZERO, cam_zoom: float = 1.0):
	$Camera2D.position = cam_offset
	$Camera2D.zoom = Vector2(cam_zoom, cam_zoom)

func set_WateringParticles_state(state: bool) -> void:
	var pos = $Camera2D.position - Vector2(600,800)
	$WateringParticles.position = pos
	$WateringParticles.emitting = state

func set_water_level(water_level: int) -> void:
	$Ground.modulate = Color.white.darkened(water_level * WATER_LEVEL_RATE)

func change_water_level(water_level: int) -> void:
	water_amount = water_level
	var final_color = Color.white.darkened(water_level * WATER_LEVEL_RATE)
	$Tween.interpolate_property(
		$Ground, "modulate",
		$Ground.modulate,  final_color,
		WATER_COLOR_SPEED, $Tween.TRANS_SINE, $Tween.EASE_IN
	)
	$Tween.start()

func _on_WorldManager_time_changed():
	var color = WorldManager.current_color()
	$Tween.interpolate_property(
		self, "modulate",
		self.modulate, color, 
		Constants.TIME_TRANSITION_DURATION,
		Constants.TIME_TRANSITION_CURVE, Constants.TIME_TRANSITION_EASE
	)
	$Tween.start()
	
	# Wait for age
	yield(plant, "ask_for_close_up_plant")
	var camera_offset = plant.close_up_plant.get_plant_center()
	var zoom_level = Constants.ZOOM_IN_LIFE_STAGES[plant.life_stage]
	focus_camera(camera_offset, zoom_level)
