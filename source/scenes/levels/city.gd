extends Node2D


onready var road_modulate: CanvasModulate = $RoadParallax/CanvasModulate
onready var background_modulate: CanvasModulate = $ParallaxBackground/CanvasModulate
onready var actors: YSort = $Actors


func _ready() -> void:
	randomize()
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")


func _on_time_of_day_changed(state):
	match state: 
		Globals.DAY:
			background_modulate.color = Globals.DAY_MODULATE
#			foreground_modulate.color = Globals.DAY_MODULATE
			road_modulate.color = Globals.DAY_MODULATE
			actors.modulate = Globals.DAY_MODULATE
		Globals.NIGHT: 
			background_modulate.color = Globals.NIGHT_MODULATE
			road_modulate.color = Globals.NIGHT_MODULATE
#			foreground_modulate.color = Color("#565656")
			actors.modulate = Globals.NIGHT_MODULATE
