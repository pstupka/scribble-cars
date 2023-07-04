extends Node


const DAY = 0
const NIGHT = 1

const DAY_MODULATE := Color("#ffffff")
const NIGHT_MODULATE := Color("#676767")

const ROAD_MIN_POSITION := 410.0
const ROAD_MAX_POSITION := 480.0

var daynight := DAY setget set_daynight

var score: int

var paused: bool = false

var car_templates:Dictionary = {
	"tractor": preload("res://source/scenes/actors/car_templates/tractor.tscn"),
	"tractor2": preload("res://source/scenes/actors/car_templates/tractor2.tscn"),
	"car1": preload("res://source/scenes/actors/car_templates/car1.tscn"),
	"car_police": preload("res://source/scenes/actors/car_templates/car_police.tscn"),
	"car3": preload("res://source/scenes/actors/car_templates/car3.tscn"),
	"car4": preload("res://source/scenes/actors/car_templates/car4.tscn"),
	"bus2": preload("res://source/scenes/actors/car_templates/bus2.tscn"),
	"bus3": preload("res://source/scenes/actors/car_templates/bus3.tscn"),
	"bus": preload("res://source/scenes/actors/car_templates/bus.tscn"),
	"car_ambulance": preload("res://source/scenes/actors/car_templates/car_ambulance.tscn"),
	"car_template": preload("res://source/scenes/actors/car_templates/car_template.tscn"),
	"cabrio": preload("res://source/scenes/actors/car_templates/cabrio.tscn"),
	"fish_bus": preload("res://source/scenes/actors/car_templates/fish_bus.tscn"),
	"bus4": preload("res://source/scenes/actors/car_templates/bus4.tscn"),
	"bus5": preload("res://source/scenes/actors/car_templates/bus5.tscn"),
	"bus6": preload("res://source/scenes/actors/car_templates/bus6.tscn"),
	"firetruck1": preload("res://source/scenes/actors/car_templates/car_firetruck1.tscn"),
	"firetruck2": preload("res://source/scenes/actors/car_templates/car_firetruck2.tscn"),
	"firetruck3": preload("res://source/scenes/actors/car_templates/car_firetruck3.tscn"),
	"car_kia": preload("res://source/scenes/actors/car_templates/car_kia.tscn"),
}

var available_cars: = {
	"forest": ["car_kia", "car_template", "tractor", "car1", "tractor2", "car3", "car4", "cabrio", "bus2", "car_police"],
	"city": ["bus3", "bus6", "bus4", "bus", "fish_bus", "bus5", "car_ambulance", "car_police"],
	"firetruck": ["firetruck1", "firetruck2", "firetruck3"]
}

var available_random_cars: = {
	"forest": ["car_template", "car_kia", "tractor", "car1", "tractor2", "car3", "car4", "bus2", "car_police", "firetruck1"],
	"city": ["car3", "car_kia", "cabrio", "car1", "car_template", "car_ambulance", "car4", "car_police", "firetruck1"],
	"firetruck": ["car3", "car_kia", "cabrio", "car1", "car_template", "car_ambulance", "car4", "car_police", "bus3", "bus5"]
}

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

var colors_str: Array = [
	"#f2f0e5",
	"#b8b5b9",
	"#868188",
	"#646365",
	"#45444f",
	"#3a3858",
	"#212123",
	"#352b42",
	"#43436a",
	"#4b80ca",
	"#68c2d3",
	"#a2dcc7",
	"#ede19e",
	"#d3a068",
	"#b45252",
	"#6a536e",
	"#4b4158",
	"#80493a",
	"#a77b5b",
	"#e5ceb4",
	"#c2d368",
	"#8ab060",
	"#567b79",
	"#4e584a",
	"#7b7243",
	"#b2b47e",
	"#edc8c4",
	"#cf8acb",
	"#5f556a",
	]

var camera

func set_daynight(new_state):
	if new_state in [DAY, NIGHT]:
		daynight = new_state
		Events.emit_signal("time_of_day_changed", new_state)


func vibrate() -> void:
	if (Input.get_connected_joypads().size() > 0 and Settings.get("vibrations_enabled")):
		Input.start_joy_vibration(0, 0.4, 0.0, 0.4)
	if (OS.get_name() == "Android" or OS.get_name() == "HTML5") and Settings.get("vibrations_enabled"):
		Input.vibrate_handheld(200)
