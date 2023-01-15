extends Node


const DAY = 0
const NIGHT = 1

const DAY_MODULATE := Color("#ffffff")
const NIGHT_MODULATE := Color("#676767")

const ROAD_MIN_POSITION := 410.0
const ROAD_MAX_POSITION := 480.0

var daynight := DAY setget set_daynight

var car_templates : Array = [
	preload("res://source/scenes/actors/car_templates/car1.tscn"),
	preload("res://source/scenes/actors/car_templates/car_template.tscn"),
	preload("res://source/scenes/actors/car_templates/car_police.tscn"),
]

var available_colors = [
	Color("cf8acb"),
	Color("7b7243"),
	Color("b45252"),
	Color("4b80ca"),
	Color("6a536e"),
	Color("567b79"),
	Color("d3a068"),
	Color("646365"),
]

func set_daynight(new_state):
	if new_state in [DAY, NIGHT]:
		daynight = new_state
		Events.emit_signal("time_of_day_changed", new_state)
