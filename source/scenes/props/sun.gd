extends Node2D

var tween

func _ready() -> void:
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")
	_on_time_of_day_changed(Globals.daynight)


func _on_time_of_day_changed(state):
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()

	match state:
		Globals.DAY:
			tween.tween_callback($Light2D, "set_enabled", [true]).set_delay(0.3)
		Globals.NIGHT:
			tween.tween_callback($Light2D, "set_enabled", [false])
