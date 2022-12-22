extends Node2D

var current_state = Globals.DAY setget set_state
onready var apple_timer = $AppleTimer

onready var background_modulate = $ParallaxBackground/CanvasModulate
onready var road_modulate = $RoadParallax/CanvasModulate
onready var foreground_modulate = $ParallaxBackground2/CanvasModulate
onready var actors = $Actors

func _ready():
	randomize()
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")

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
			road_modulate.color = Globals.DAY_MODULATE
			actors.modulate = Globals.DAY_MODULATE
			
		Globals.NIGHT:
			background_modulate.color = Globals.NIGHT_MODULATE
			road_modulate.color = Globals.NIGHT_MODULATE
			foreground_modulate.color = Color("#565656")
			actors.modulate = Globals.NIGHT_MODULATE
	current_state = new_state
	Events.emit_signal("time_of_day_changed", current_state)


func _on_AppleTimer_timeout():
	var trees = get_tree().get_nodes_in_group("tree")
	trees[randi() % trees.size()].make_fruit()


func _on_time_of_day_changed(state):
	match state:
		Globals.DAY:
			apple_timer.paused = false
		Globals.NIGHT:
			apple_timer.paused = true
