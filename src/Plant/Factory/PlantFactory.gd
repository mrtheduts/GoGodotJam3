#
# PlantFactory.gd - Generator of plants
#

extends Node

var PLANT_CLASS = preload("res://src/Plant/Plant.gd")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print(gen_random_plant().genetics)
	print(gen_random_plant().genetics)
	print(gen_random_plant().genetics)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func gen_random_plant() -> Plant:
	var new_plant: Plant = PLANT_CLASS.new()
	for feature in DNA.FEATURES:
		for n in DNA.NUM_ALLELES:
			randomize()
			var feature_values: Array = DNA[feature + "_VALUES"].keys()
			feature_values.shuffle()
			
			var gene = feature_values.pop_front()
			new_plant.add_gene(feature, gene)
	return new_plant
