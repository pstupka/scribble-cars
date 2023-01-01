extends Node


const DAY = 0
const NIGHT = 1

const DAY_MODULATE := Color("#ffffff")
const NIGHT_MODULATE := Color("#676767")

const ROAD_MIN_POSITION := 410.0
const ROAD_MAX_POSITION := 480.0

var daynight := DAY setget set_daynight

func set_daynight(new_state):
	if new_state in [DAY, NIGHT]:
		daynight = new_state
		Events.emit_signal("time_of_day_changed", new_state)


