extends VideoPlayer

func start() -> void:
	print("OI")
	self.visible = true
	$Music.play()
	self.play()

func _on_VideoPlayer_finished():
	$Tween.interpolate_property(
		$Music, "volume_db",
		$Music.volume_db, -80,
		Constants.TRANSITION_DURATION, $Tween.TRANS_LINEAR, $Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		self, "modulate",
		self.modulate, Color(0, 0, 0, 0),
		Constants.TRANSITION_DURATION, $Tween.TRANS_LINEAR, $Tween.EASE_OUT
	)
	$Tween.start()


func _on_Tween_tween_all_completed():
	visible = false
	modulate = Color.white
