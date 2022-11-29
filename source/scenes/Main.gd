extends Node2D

var current_state = Globals.DAY setget set_state
onready var background_modulate = $ParallaxBackground/CanvasModulate
onready var foreground_modulate = $ParallaxBackground2/CanvasModulate2
onready var actors = $Actors


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
			actors.modulate = Globals.DAY_MODULATE
			
		Globals.NIGHT:
			background_modulate.color = Globals.NIGHT_MODULATE
			foreground_modulate.color = Color("#565656")
			actors.modulate = Globals.NIGHT_MODULATE
	current_state = new_state
	Events.emit_signal("time_of_day_changed", current_state)
