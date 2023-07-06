extends Node2D

onready var actors: YSort = $Actors

onready var player = $Actors/Player
onready var random_car = preload("res://source/scenes/actors/random_car.tscn")
onready var transition_color: ColorRect = $CanvasLayer/ColorRect
onready var background_modulate = $ParallaxBackground/CanvasModulate
onready var foreground_modulate = $RoadParallax/CanvasModulate
onready var road_modulate = $ForegroundParallax/CanvasModulate
onready var rain = $ForegroundParallax/Rain/Rain
onready var rain_splash = $ForegroundParallax/Rain/RainSplash

export var lanes_y_position = [410, 460]
export var scene_type = "firetruck"

var tween: SceneTreeTween = null

func _ready() -> void:
	get_tree().paused = true
	$CanvasLayer.show()
	randomize()
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")
	$EnterTweener.connect("enter_tween_completed", self, "_on_enter_tween_completed")

	var tween = create_tween()
	tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(transition_color, "modulate", Color(0.13, 0.13, 0.14, 0.0), 1.0).set_delay(0.3)
	tween.tween_callback(transition_color, "call_deferred", ["queue_free"])

	yield(get_tree().create_timer(0.3),"timeout")

	$EnterTweener.apply_tween()
	Globals.score = 0


func _on_CarSpawnTimer_timeout():
	var car_instance = random_car.instance()
	var lane = stepify(randf(),1)
	actors.add_child(car_instance)
	car_instance.global_position = Vector2(player.global_position.x - (2*lane - 1)*1500, lanes_y_position[lane])
	car_instance.direction = Vector2(2*lane - 1 , 0)
	
	$CarSpawnTimer.wait_time = rand_range(5.44, 10.51)


func _on_time_of_day_changed(state):
	if tween:
		if tween.is_valid():
			tween.kill()
	tween = create_tween()
	
	match state: 
		Globals.DAY:
			tween.tween_property(background_modulate, "color", Globals.DAY_MODULATE, 2.0)
			tween.parallel().tween_property(foreground_modulate, "color", Globals.DAY_MODULATE, 2.0)
			tween.parallel().tween_property(road_modulate, "color", Globals.DAY_MODULATE, 2.0)
			tween.parallel().tween_property(actors, "modulate", Globals.DAY_MODULATE, 2.0)
			rain.emitting = false
			rain_splash.emitting = false
		Globals.NIGHT:
			tween.tween_property(background_modulate, "color", Color("#c0c0c0"), 2.0)
			tween.parallel().tween_property(foreground_modulate, "color", Color("#c0c0c0"), 2.0)
			tween.parallel().tween_property(road_modulate, "color", Color("#c0c0c0"), 2.0)
			tween.parallel().tween_property(actors, "modulate", Color("#c0c0c0"), 2.0)
			rain.emitting = true
			rain_splash.emitting = true


func _on_enter_tween_completed():
	get_tree().paused = false


func _on_WeatherTimer_timeout():
	if Globals.daynight == Globals.NIGHT: 
		Globals.daynight = Globals.DAY
		$WeatherTimer.start(rand_range(60.0, 120.0)) 
		Events.emit_signal("rain_state_changed", false)
	else:
		Globals.daynight = Globals.NIGHT
		$WeatherTimer.start(30.0) 
		Events.emit_signal("rain_state_changed", true)

