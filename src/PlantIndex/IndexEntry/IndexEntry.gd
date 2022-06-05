extends MarginContainer
class_name IndexEntry

# References of the feature list, name label and texture rect
onready var _feature_list: ItemList = $VBoxContainer/DataContainer/FeatureList
onready var _name_edit: LineEdit = $VBoxContainer/DataContainer/Name
onready var _image: TextureRect = $VBoxContainer/Photo
onready var _label: Label = $VBoxContainer/DataContainer/Label

var _plant: Plant = null
var _page: int

func init_plant(plant: Plant, page: int):
	_plant = plant
	_page = page
	var features: Dictionary = plant.phenotype
	var size = features.size()
	
	clear_list()
	set_list_size(size)
	
	# Features
	var item_string
	var feat_keys = features.keys()
	for i in size:
		var key = feat_keys[i]
		item_string = key + ": " + String(features[key])
		add_feature(item_string)
	
	_label.text = "Page " + String(_page)
	# Name and photo
	if PlayerState.check_plant(plant):
		_name_edit.editable = true
		_name_edit.text = plant.name
		
		var texture = ImageTexture.new()
		texture.create_from_image(plant.last_photo)
		_image.texture = texture
	else:
		_name_edit.editable = false
		_name_edit.text = Constants.LOCKED_PLANT_NAME
		
func add_feature(text: String):
	_feature_list.add_item(text)

func set_list_size(size: int):
	_feature_list.max_text_lines = size

func clear_list():
	_feature_list.clear()

func _on_Name_text_changed(new_text: String) -> void:
	_plant.name = new_text
