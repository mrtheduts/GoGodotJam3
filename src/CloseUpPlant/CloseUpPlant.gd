#
# CloseUpPlant.gd
#

extends Node2D

class_name CloseUpPlant

var ROOT_SCENE = preload("res://src/CloseUpPlant/Roots/Roots.tscn")
var STALK_SCENE = preload("res://src/CloseUpPlant/Stalks/Stalks.tscn")
var BRANCH_SCENE = preload("res://src/CloseUpPlant/Branches/Branch.tscn")
var LEAF_SCENE = preload("res://src/CloseUpPlant/Leaves/Leaf.tscn")
var FRUIT_SCENE = preload("res://src/CloseUpPlant/Fruits/Fruit.tscn")
var FLOWER_SCENE = preload("res://src/CloseUpPlant/Flowers/Flower.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var stalk = STALK_SCENE.instance()
	add_child(stalk)
	
	var root = ROOT_SCENE.instance()
	stalk.add_to_skel_down(root)
	stalk.start_wind_animation()
	
	var branch = BRANCH_SCENE.instance()
	stalk.add_to_skel_up(branch)
	branch.rotation = PI/2
	branch.start_idle_animation()
	
	var fruit = FRUIT_SCENE.instance()
	branch.add_to_mid_bone(fruit)
	var leaf = LEAF_SCENE.instance()
	branch.add_to_end_bone(leaf)
	
	var flower = FLOWER_SCENE.instance()
	stalk.add_to_skel_top(flower)
	flower.rotation = PI/2
	flower.scale.x = -flower.scale.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
