#
# CloseUpFactory.gd - Creator of CloseUpPlants
#

extends Node

var CLOSE_UP_PLANT_SCENE = preload("res://src/CloseUpPlant/CloseUpPlant.tscn")

func create_close_up_plant_from(plant: Plant) -> CloseUpPlant:
	var close_up_plant: CloseUpPlant = CLOSE_UP_PLANT_SCENE.instance()
	
	for feature in plant.phenotype.keys():
		var feature_type = DNA[feature + DNA.TYPE_POSTFIX]
		var gene = plant.phenotype[feature]
		
	return close_up_plant
