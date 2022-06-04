extends VBoxContainer

var SEED_SCENE = load("res://src/CloseUpPlant/Seed/Seed.tscn")

const SEED_PADDING : Vector2 = Vector2(35,60)
const SEED_SCALE : Vector2 = Vector2(3.5,3.5)

var item : Dictionary = {}
var id : int = -1

func _ready():
	Utils.conn_nodes($TextureFrame, "mouse_entered", self, "_on_ItemSlot_mouse_entered")
	Utils.conn_nodes($TextureFrame, "mouse_exited", self, "_on_ItemSlot_mouse_exited")
	
	$Label_Tooltip.text = " "

func _on_ItemSlot_mouse_entered():
	$Label_Tooltip.text = item["name"]
	
func _on_ItemSlot_mouse_exited():
	$Label_Tooltip.text = " "
					
func update_item(slot_id: int, slot_item: Dictionary, item_quantity: String):
	clear_seed()
	id = slot_id
	item = slot_item
	$TextureFrame/ItemIcon.texture = null

	if slot_item["id"] == String(Constants.SEED_ITEM_ID):
		var new_seed = SEED_SCENE.instance()
		new_seed.init_seed(PlayerState._inventory[String(slot_id)]["seed_obj"])
		add_child(new_seed)
		new_seed.position += SEED_PADDING
		new_seed.scale = SEED_SCALE
	elif item["name"] != "":
		$TextureFrame/ItemIcon.texture = ResourceLoader.load(item["icon"])
		center_icon()
		
	$TextureFrame/Label_Amount.text = item_quantity

func center_icon():
	var icon_size = $TextureFrame/ItemIcon.texture.get_size()
	var center_pos = Vector2($TextureFrame.rect_size.x/2 - icon_size.x/2, $TextureFrame.rect_size.y/2 - icon_size.y/2)
	$TextureFrame/ItemIcon.set_position(center_pos)

func clear_seed():
	for child in get_children():
		if child is Node2D:
			child.queue_free()
