extends Node2D

const GREEN : Color = Color(0.611765, 0.839216, 0.611765)
const RED : Color = Color(0.858824,0.603922,0.635294)
const BLUE : Color = Color(0.619608,0.709804,0.886275)
const WHITE : Color = Color(0.760784,0.760784,0.760784)
const BLACK : Color = Color(0.427451,0.427451,0.427451)

var COLOR_MAPPING := {
	"RED": RED,
	"GRN": GREEN,
	"BLU": BLUE,
	"WHT": WHITE,
	"BLK": BLACK
}

var seed_plant : Plant = null

func middle_color(first_color: Color, second_color: Color) -> Color:
	return (first_color + second_color)/2

func init_seed(plant: Plant):
	seed_plant = plant
	
	var plant_genetics : Dictionary = seed_plant.genetics
	
	var fruit_colors : Array = plant_genetics["FRUIT_COLOR"]
	var flower_colors : Array = plant_genetics["FLOWER_COLOR"]
	
	$Fruit_Color_1.modulate = COLOR_MAPPING[fruit_colors[0]]
	$Mid_Color_1.modulate = middle_color(COLOR_MAPPING[fruit_colors[0]], COLOR_MAPPING[flower_colors[0]])
	$Flower_Color_1.modulate = COLOR_MAPPING[flower_colors[0]]
	$Mid_Color_2.modulate = middle_color(COLOR_MAPPING[flower_colors[0]], COLOR_MAPPING[fruit_colors[1]])
	$Fruit_Color_2.modulate = COLOR_MAPPING[fruit_colors[1]]
	$Mid_Color_3.modulate = middle_color(COLOR_MAPPING[fruit_colors[1]], COLOR_MAPPING[flower_colors[1]])
	$Flower_Color_2.modulate = COLOR_MAPPING[flower_colors[1]]
