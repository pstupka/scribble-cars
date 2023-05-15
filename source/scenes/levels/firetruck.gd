extends Node2D

onready var actors: YSort = $Actors

onready var player = $Actors/Player
onready var random_car = preload("res://source/scenes/actors/random_car.tscn")
onready var transition_color: ColorRect = $CanvasLayer/ColorRect

export var lanes_y_position = [410, 460]
export var scene_type = "firetruck"


func _ready() -> void:
	randomize()
	Events.connect("time_of_day_changed", self, "_on_time_of_day_changed")
	$EnterTweener.connect("enter_tween_completed", self, "_on_enter_tween_completed")

	var tween = create_tween()
	tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(transition_color, "modulate", Color(0.0, 0.0, 0.0, 0.0), 1.0)
	tween.tween_callback(transition_color, "call_deferred", ["queue_free"])

	yield(get_tree().create_timer(0.3),"timeout")
	get_tree().paused = false
	$EnterTweener.apply_tween()
	Globals.score = 0


func _on_CarSpawnTimer_timeout():
	var car_instance = random_car.instance()
	var lane = stepify(randf(),1)
	actors.add_child(car_instance)
	car_instance.global_position = Vector2(player.global_position.x - (2*lane - 1)*1500, lanes_y_position[lane])
	car_instance.direction = Vector2(2*lane - 1 , 0)
	
	$CarSpawnTimer.wait_time = rand_range(5.44, 10.51)


func _on_enter_tween_completed():
	get_tree().paused = false
