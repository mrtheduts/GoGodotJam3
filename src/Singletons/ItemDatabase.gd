extends Node

onready var itemData : Dictionary = load_data("res://datasets/items_dataset.json")

func get_item(id: String) -> Dictionary:
	if !itemData.has(id):
		print("Item does not exist.")
		return {}

	itemData[(id)]["id"] = (id)
	return itemData[(id)]

func load_data(url) -> Dictionary:
	var file = File.new()
	
	if url == null: return {}
	
	if !file.file_exists(url): return {}
	
	file.open(url, File.READ)
	
	var data:Dictionary = {}
	
	data = parse_json(file.get_as_text())
	file.close()
	return data
