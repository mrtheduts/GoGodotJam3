extends Node


# Declare member variables here. Examples:
var SAVE_FILENAME = "user://savegame.save"
var SAVE_FUNC_NAME = "save_stats"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_pressed("save"):
		save_game()
		

func save_game():
	print("Saving Game")
	
	var save_game = File.new()
	save_game.open(SAVE_FILENAME, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	print(save_nodes)
	
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method(SAVE_FUNC_NAME):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call(SAVE_FUNC_NAME)
		
		# var node_details = node.get_save_stats()

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()
	
func load_game():
	print("Loading Game")
	
	var save_game = File.new()
	if not save_game.file_exists(SAVE_FILENAME):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open(SAVE_FILENAME, File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		
		new_object.load_stats(node_data)

		# Now we set the remaining variables.
		#for i in node_data.keys():
		#	if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
		#		continue
		#	new_object.set(i, node_data[i])

	save_game.close()
