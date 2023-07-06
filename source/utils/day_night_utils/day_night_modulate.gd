extends Node2D

export var day_color := Color("ffffff")
export var night_color := Color("ffffff")
export var use_self_modulate = false

func _ready() -> void:
	var _err = Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")
	_on_time_of_day_changed(Globals.daynight)


func _on_time_of_day_changed(state):
	match state:
		Globals.DAY:
			if use_self_modulate:
				get_parent().self_modulate = day_color
			else:
				get_parent().modulate = day_color
		Globals.NIGHT:
			if use_self_modulate:
				get_parent().self_modulate = night_color
			else:
				get_parent().modulate = night_color
