extends Node2D

var current_state = States.NIGHT setget set_state
onready var background_modulate = $ParallaxBackground/CanvasModulate
onready var foreground_modulate = $ParallaxBackground2/CanvasModulate3


func _input(event):
	if event.is_action_pressed("lights"):
		if current_state == States.NIGHT:
			set_state(States.DAY)
		else:
			set_state(States.NIGHT)


func set_state(new_state):
	match new_state:
		States.DAY:
			background_modulate.color = Color("#ffffff")
			foreground_modulate.color = Color("#ffffff")
		States.NIGHT:
			background_modulate.color = Color("#262626")
			foreground_modulate.color = Color("#262626")
	current_state = new_state
	Events.emit_signal("time_of_day_changed", current_state)
