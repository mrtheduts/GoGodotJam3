extends Node2D

class_name CloseUpPlot

func _ready():
	Utils.conn_nodes(WorldManager, "time_changed", self, "_on_WorldManager_time_changed")
	self.modulate = WorldManager.current_color()

func add_node_and_focus_camera(new_node: Node2D, cam_offset: Vector2 = Vector2.ZERO, cam_zoom: float = 1.0):
	add_child(new_node)
	$Camera2D.position += cam_offset
	$Camera2D.zoom = Vector2(cam_zoom, cam_zoom)

func set_WateringParticles_state(state: bool) -> void:
	var pos = $Camera2D.position - Vector2(600,800)
	$WateringParticles.position = pos
	$WateringParticles.emitting = state

func _on_WorldManager_time_changed():
	var color = WorldManager.current_color()
	$Tween.interpolate_property(
		self, "modulate",
		self.modulate, color, 
		Constants.TIME_TRANSITION_DURATION,
		Constants.TIME_TRANSITION_CURVE, Constants.TIME_TRANSITION_EASE
	)
	$Tween.start()
