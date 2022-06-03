extends Node2D

class_name CloseUpPlot

const WATER_LEVEL_RATE := 0.05
const WATER_COLOR_SPEED := 0.75

func add_node_and_focus_camera(new_node: Node2D, cam_offset: Vector2 = Vector2.ZERO, cam_zoom: float = 1.0):
	add_child(new_node)
	$Camera2D.position += cam_offset
	$Camera2D.zoom = Vector2(cam_zoom, cam_zoom)

func set_WateringParticles_state(state: bool) -> void:
	var pos = $Camera2D.position - Vector2(600,800)
	$WateringParticles.position = pos
	$WateringParticles.emitting = state

func change_water_level(water_level: int) -> void:
	var final_color = Color.white.darkened(water_level * WATER_LEVEL_RATE)
	$Tween.interpolate_property(
		$Ground, "modulate",
		$Ground.modulate,  final_color,
		WATER_COLOR_SPEED, $Tween.TRANS_SINE, $Tween.EASE_IN
	)
	$Tween.start()
