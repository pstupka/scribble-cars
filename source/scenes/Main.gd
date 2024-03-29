extends Node2D

onready var apple_timer = $AppleTimer

onready var background_modulate = $ParallaxBackground/CanvasModulate
onready var road_modulate = $RoadParallax/CanvasModulate
onready var foreground_modulate = $ParallaxBackground2/CanvasModulate
onready var actors = $Actors
onready var player = $Actors/Player
onready var transition_color = $CanvasLayer/ColorRect
export var scene_type = "forest"


export var lanes_y_position = [410, 460]

onready var random_car = preload("res://source/scenes/actors/random_car.tscn")


func _ready():
	$CanvasLayer.show()
	randomize()
	var _err = Events.connect ("time_of_day_changed", self, "_on_time_of_day_changed")
	_err = $EnterTweener.connect("enter_tween_completed", self, "_on_enter_tween_completed")

	var tween = create_tween()
	tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(transition_color, "modulate", Color(0.13, 0.13, 0.14, 0.0), 1.0).set_delay(0.3)
	tween.tween_callback(transition_color, "call_deferred", ["queue_free"])

	yield(get_tree().create_timer(0.3),"timeout")
	get_tree().paused = true
	$EnterTweener.apply_tween()
	Globals.score = 0


func _input(event):
	if event.is_action_pressed("lights"):
		if Globals.daynight == Globals.NIGHT: 
			Globals.daynight = Globals.DAY
		else:
			Globals.daynight = Globals.NIGHT


func _on_AppleTimer_timeout():
	var trees = get_tree().get_nodes_in_group("tree")
	trees[randi() % trees.size()].make_fruit()


func _on_time_of_day_changed(state):
	match state: 
		Globals.DAY:
			apple_timer.paused = false
			background_modulate.color = Globals.DAY_MODULATE
			foreground_modulate.color = Globals.DAY_MODULATE
			road_modulate.color = Globals.DAY_MODULATE
			actors.modulate = Globals.DAY_MODULATE
		Globals.NIGHT:
			apple_timer.paused = true
			background_modulate.color = Globals.NIGHT_MODULATE
			road_modulate.color = Globals.NIGHT_MODULATE
			foreground_modulate.color = Color("#565656")
			actors.modulate = Globals.NIGHT_MODULATE


func _on_CarSpawnTimer_timeout():
	var car_instance = random_car.instance()
	var lane = stepify(randf(),1)
	actors.add_child(car_instance)
	car_instance.global_position = Vector2(player.global_position.x - (2*lane - 1)*1500, lanes_y_position[lane])
	car_instance.direction = Vector2(2*lane - 1 , 0)
	
	$CarSpawnTimer.wait_time = rand_range(5.44, 10.51)


func _on_enter_tween_completed():
	get_tree().paused = false
