extends VBoxContainer

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
					
func update_item(slot_id: int, slot_item: Dictionary, item_q: String):
	id = slot_id
	item = slot_item
	
	if item["name"] != "":
		$TextureFrame/ItemIcon.texture = ResourceLoader.load(item["icon"])
		center_icon()
	else:
		$TextureFrame/ItemIcon.texture = null
		
	$TextureFrame/Label_Amount.text = item_q

func center_icon():
	var icon_size = $TextureFrame/ItemIcon.texture.get_size()
	var center_pos = Vector2($TextureFrame.rect_size.x/2 - icon_size.x/2, $TextureFrame.rect_size.y/2 - icon_size.y/2)
	$TextureFrame/ItemIcon.set_position(center_pos)
