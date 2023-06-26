extends Sprite


func _ready():
	var _err = Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")
	_on_time_of_day_changed(Globals.daynight)


func _on_time_of_day_changed(state):
	match state: 
		Globals.DAY:
			$RainbowTimer.start()
			self_modulate = Color.white
			show()
		Globals.NIGHT:
			var tween = create_tween()
			tween.tween_callback(self, "hide").set_delay(2.0)

func _on_RainbowTimer_timeout():
	var tween = create_tween()
	tween.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 10.0)
	
