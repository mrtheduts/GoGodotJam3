extends Node2D

class_name OverviewPlant 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_age(age : int):
	match age:
		Constants.LIFE_STAGES.SEED:
			$Seed.visible = true
			$Sprout.visible = false
			$Teenage.visible = false
			$Adult.visible = false
			$Dead.visible = false
		Constants.LIFE_STAGES.SPROUT:
			$Seed.visible = false
			$Sprout.visible = true
			$Teenage.visible = false
			$Adult.visible = false
			$Dead.visible = false
		Constants.LIFE_STAGES.TEENAGE:
			$Seed.visible = false
			$Sprout.visible = false
			$Teenage.visible = true
			$Adult.visible = false
			$Dead.visible = false
		Constants.LIFE_STAGES.ADULT:
			$Seed.visible = false
			$Sprout.visible = false
			$Teenage.visible = false
			$Adult.visible = true
			$Dead.visible = false
		Constants.LIFE_STAGES.DEAD:
			$Seed.visible = false
			$Sprout.visible = false
			$Teenage.visible = false
			$Adult.visible = false
			$Dead.visible = true
			printerr("I'm dead! :(")

func set_flower_color(color : Color):
	$Adult/Polygon2D.color = color
