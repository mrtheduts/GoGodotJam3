extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate = Color.black
	$MainContainer/StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	$Tween.interpolate_property(
		self, "modulate",
		self.modulate, Color.black,
		Constants.TRANSITION_DURATION, $Tween.TRANS_SINE, $Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		$Music, "volume_db",
		$Music.volume_db, -80,
		Constants.TRANSITION_DURATION, $Tween.TRANS_SINE, $Tween.EASE_OUT
	)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	get_tree().change_scene("res://src/Main/Main.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_Tween_tree_entered():
	$Tween.interpolate_property(
		self, "modulate",
		Color.black, Color.white,
		Constants.TRANSITION_DURATION, $Tween.TRANS_SINE, $Tween.EASE_OUT
	)
	$Tween.start()


func _on_CreditsButton_pressed():
	$Music.stream_paused = true
	$VideoPlayer.start()


func _on_VideoPlayer_hide():
	$Music.stream_paused = false
