extends Node2D

export var day_color := Color("ffffff")
export var night_color := Color("ffffff")

func _ready() -> void:
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")
	_on_time_of_day_changed(Globals.daynight)


func _on_time_of_day_changed(state):
	match state:
		Globals.DAY:
			get_parent().modulate = day_color
		Globals.NIGHT:
			get_parent().modulate = night_color
