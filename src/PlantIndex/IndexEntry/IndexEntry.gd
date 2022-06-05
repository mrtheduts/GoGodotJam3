extends MarginContainer
class_name IndexEntry

# References of the feature list, name label and texture rect
onready var _feature_list: ItemList = $VBoxContainer/DataContainer/FeatureList
onready var _name_edit: LineEdit = $VBoxContainer/DataContainer/Name
onready var _image: TextureRect = $VBoxContainer/Photo
onready var _label: Label = $VBoxContainer/DataContainer/Label

var _plant: Plant = null
var _page: int
var _list_size := 0

enum ArrayType { COLOR }
var _color_dict := {
	'RED':'Red',
	'BLU':'Blue',
	'GRN':'Green',
	'WHT':'White',
	'BLK':'Black'
}
var _array_dicts: Array = [_color_dict]

var _default_names := {
	'ROOT':'Fibrous',
	'FLOWER':'Daisy',
	'FRUIT':'Apple',
	'STALK':'Regular',
	'LEAF':'Regular',
	'BRANCH':'Straight'
}

func init_plant(plant: Plant, page: int):
	_plant = plant
	_page = page
	var features: Dictionary = plant.phenotype.duplicate(true)
	
	clear_list()
	list_features(features)
	set_list_size()
	
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
	_feature_list.set_item_selectable(_list_size, false)
	_list_size += 1
	
func set_list_size():
	_feature_list.max_text_lines = _list_size

func clear_list():
	_feature_list.clear()

func list_features(features: Dictionary):
	var item_string
	var feat_keys = features.keys()
	
	# Boolean features
	for key in feat_keys:
		var feat_words: PoolStringArray = key.split('_')
		
		# Boolean features
		# Find and return color.
		if feat_words[0] == "HAS":
			var value = Utils.as_bool(features[key])
			features.erase(key)
			if not value:
				feat_words.remove(0)
				key = feat_words.join('_')
				features.erase(key + '_COLOR')
				features.erase(key + '_TYPE')
			else:
				continue
			
			for i in feat_words.size():
				feat_words[i] = feat_words[i].capitalize()

			add_feature("No " + feat_words.join(' '))
	
	# Go through the other keys
	for key in features:
		var feat_words: PoolStringArray = key.split('_')
		var value = features[key]
		
		# Array values
		if value is Array:
			if feat_words[-1] == 'COLOR':
				value = translate_array(ArrayType.COLOR, value)
			else:
				print('Something very wrong happened!')
		elif value == 'DEFAULT':
			value = _default_names[feat_words[0]]

		# Format key
		for i in feat_words.size():
			feat_words[i] = feat_words[i].capitalize()
		var feat = feat_words.join(' ')
		
		# Create string
		item_string = feat + ": " + String(value).capitalize()
		
		# Add string
		add_feature(item_string)

func translate_array(type: int, values: PoolStringArray) -> String:
	var dict = _array_dicts[type]
	var el_array: PoolStringArray = []
	for v in values:
		var element = dict[v]
		if not element in el_array:
			el_array.append(element)
	return el_array.join(' + ')

func _on_Name_text_changed(new_text: String) -> void:
	_plant.name = new_text
