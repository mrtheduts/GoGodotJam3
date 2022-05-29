extends Node2D

var CLOSE_UP_SCENE = preload("res://src/CloseUpPlant/CloseUpPlant.tscn")

func _ready():
	var plant = CLOSE_UP_SCENE.instance()
	add_node_and_focus_camera(plant)

func add_node_and_focus_camera(new_node: Node2D, cam_offset: Vector2 = Vector2.ZERO, cam_zoom: float = 1.0):
	add_child(new_node)
	$Camera2D.position += cam_offset
	$Camera2D.zoom = Vector2(cam_zoom, cam_zoom)
