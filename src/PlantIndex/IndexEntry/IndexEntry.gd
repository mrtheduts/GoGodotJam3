extends MarginContainer

# References of the feature list and name label
onready var _feature_list: ItemList = $HBoxContainer/VBoxContainer/FeatureList
onready var _name_edit: LineEdit = $HBoxContainer/VBoxContainer/Name

# Called when the node enters the scene tree for the first time.
func _ready():

	_name_edit.editable = false
	_name_edit.text = "LOCKED"

	var plant = PlantFactory.gen_random_plant()
	init_plant(plant)
	print(_feature_list.items)

func init_plant(plant: Plant):
	var features: Dictionary = plant.phenotype
	var size = features.size()
	set_list_size(size)
	
	var item_string
	var feat_keys = features.keys()
	for i in size:
		var key = feat_keys[i]
		item_string = key + ": " + String(features[key])
		add_feature(item_string)

func add_feature(text: String):
	print(text)
	_feature_list.add_item(text)

func set_list_size(size: int):
	_feature_list.max_text_lines = size
