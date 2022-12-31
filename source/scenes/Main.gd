extends Node2D

var current_state = Globals.DAY setget set_state
onready var apple_timer = $AppleTimer

onready var background_modulate = $ParallaxBackground/CanvasModulate
onready var road_modulate = $RoadParallax/CanvasModulate
onready var foreground_modulate = $ParallaxBackground2/CanvasModulate
onready var actors = $Actors
onready var player = $Actors/Player

export var lanes_y_position = [410, 460]

onready var car_templates = [
	preload("res://source/scenes/actors/police_car.tscn")
]

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


func _on_CarSpawnTimer_timeout():
	var car_instance = car_templates[0].instance()
	var lane = stepify(randf(),1)
	actors.add_child(car_instance)
	car_instance.global_position = Vector2(player.global_position.x - (2*lane - 1)*1500, lanes_y_position[lane])
	car_instance.direction = Vector2(2*lane - 1 , 0)
	
	
