extends Node2D

var current_state = Globals.DAY setget set_state
onready var background_modulate = $ParallaxBackground/CanvasModulate
onready var foreground_modulate = $ParallaxBackground2/CanvasModulate2

onready var trees = [
	$ParallaxBackground/Trees2/Tree1,
	$ParallaxBackground/Trees2/Tree2,
	$ParallaxBackground/Trees1/Tree3,
	$ParallaxBackground/Trees1/Tree4,
	$ParallaxBackground2/Trees3/Tree5,
	$ParallaxBackground2/Trees3/Tree6
]

func _input(event):
	if event.is_action_pressed("lights"):
		if current_state == Globals.NIGHT:
			set_state(Globals.DAY)
		else:
			set_state(Globals.NIGHT)


func set_state(new_state):
	match new_state:
		Globals.DAY:
			background_modulate.color = Globals.DAY_MODULATE
			foreground_modulate.color = Globals.DAY_MODULATE
		Globals.NIGHT:
			background_modulate.color = Globals.NIGHT_MODULATE
			foreground_modulate.color = Color("#565656")
	current_state = new_state
	Events.emit_signal("time_of_day_changed", current_state)
